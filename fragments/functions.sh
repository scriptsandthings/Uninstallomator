# MARK: Functions

# --- Logging ---
# levels: DEBUG < INFO < WARN < ERROR < REQ
declare -A levels=( [DEBUG]=0 [INFO]=1 [WARN]=2 [ERROR]=3 [REQ]=4 )
log_location="/private/var/log/Uninstallomator.log"

printlog() { # $1 message, $2 level (default INFO)
  local msg="$1" lvl="${2:-INFO}" ts
  ts=$(date +%F\ %T)

  # de-dup consecutive lines
  if [[ "$msg" == "${previous_log_message:-}" ]]; then
    ((logrepeat=logrepeat+1))
    return
  fi
  if (( logrepeat > 1 )); then
    echo "$ts : ${lvl} : $label : Last Log repeated ${logrepeat} times" | tee -a "$log_location"
    logrepeat=0
  fi
  previous_log_message="$msg"

  # honor LOGGING threshold
  if (( ${levels[$lvl]:-1} >= ${levels[${LOGGING:-INFO}]:-1} )); then
    if [[ $EUID -eq 0 ]]; then
      echo "$ts : ${lvl} : $label : $msg" | tee -a "$log_location"
    else
      echo "$ts : ${lvl} : $label : $msg"
    fi
  fi
}

# --- Cleanup and exit ---
cleanupAndExit() { # $1 code, $2 message, $3 level (default INFO)
  local code="${1:-0}" msg="${2:-}" lvl="${3:-INFO}"
  [[ -n "$msg" ]] && printlog "$msg" "$lvl"
  printlog "################## End Uninstallomator, exit code $code" REQ
  exit "$code"
}

# --- Current user / run as user ---
get_current_user() { scutil <<<"show State:/Users/ConsoleUser" | awk '/Name :/ {print $3}'; }
runAsUser() {
  local cu; cu=$(get_current_user)
  [[ -z "$cu" || "$cu" == "loginwindow" ]] && return 0
  local uid; uid=$(id -u "$cu")
  launchctl asuser "$uid" sudo -u "$cu" "$@"
}

# --- Notifications (optional) ---
displaynotification(){ # $1 msg, $2 title
  local message="${1:-Message}" title="${2:-Notification}"
  local manageaction="/Library/Application Support/JAMF/bin/Management Action.app/Contents/MacOS/Management Action"
  local hubcli="/usr/local/bin/hubcli" swiftdialog="/usr/local/bin/dialog"
  if [[ -x "$swiftdialog" && "${NOTIFY_DIALOG:-0}" -eq 1 ]]; then
    "$swiftdialog" --notification --title "$title" --message "$message"
  elif [[ -x "$manageaction" ]]; then
    "$manageaction" -message "$message" -title "$title" &
  elif [[ -x "$hubcli" ]]; then
    "$hubcli" notify -t "$title" -i "$message" -c "Dismiss"
  else
    runAsUser osascript -e "display notification \"$message\" with title \"$title\""
  fi
}

# --- Blocking processes (simple kill policy; extend later if needed) ---
checkRunningProcesses() {
  # DEBUG==1 → skip enforcement
  [[ "${DEBUG:-0}" -eq 1 ]] && { printlog "DEBUG mode: skipping blocking process checks" DEBUG; return; }
  local counted=0 x
  for _ in {1..4}; do
    for x in "${blockingProcesses[@]}"; do
      [[ "$x" == "NONE" || -z "$x" ]] && continue
      if pgrep -xq "$x"; then
        printlog "Found blocking process: $x" INFO
        pkill "$x" || true
        sleep 5
        ((counted++))
      fi
    done
  done
  if (( counted > 0 )) && pgrep -fq "${bundle_id:-__nope__}"; then
    cleanupAndExit 11 "Could not quit all processes for $app_name; aborting." ERROR
  fi
  printlog "No blocking processes remain" INFO
}

# --- Launchd unload + file removal + receipts ---
unload_launch(){
  local p="$1"
  [[ -f "$p" ]] || return 0
  if [[ "$p" == *"/LaunchAgents/"* ]]; then
    local cu; cu=$(get_current_user); local uid; uid=$(id -u "$cu" 2>/dev/null || echo 501)
    runAsUser launchctl bootout "gui/$uid" "$p" || true
  else
    launchctl bootout system "$p" || true
  fi
  rm -f -- "$p" || true
}

# --- File removal (with confirmation and debug support) ---
confirm_rm(){
  local t="$1"
  if [[ -e "$t" || -L "$t" ]]; then
    if [[ "${DEBUG:-0}" -eq 1 ]]; then
      printlog "[DEBUG] would remove: $t" DEBUG
    else
      printlog "Removing: $t" INFO
      rm -rf -- "$t" || true
    fi
  fi
}

# --- Receipts ---
forget_pkg(){
  local id="$1"
  if pkgutil --pkgs | grep -qx "$id"; then
    if [[ "${DEBUG:-0}" -eq 1 ]]; then
      printlog "[DEBUG] would pkgutil --forget '$id'" DEBUG
    else
      pkgutil --forget "$id" || true
    fi
  fi
}

# --- Userscope helpers ---
# list_user_homes: prints "UID HOME" for each account with a uid of 500 or more and a home folder
# in /Users. Reads whole records, so the order dscl prints the two keys in does not matter.
list_user_homes(){
  dscl . -readall /Users NFSHomeDirectory UniqueID 2>/dev/null \
  | awk '
      function out() { if (h != "" && u != "" && u >= 500) print u " " h; h = ""; u = "" }
      /^-$/ { out(); next }
      /^NFSHomeDirectory:/ { h = $2 }
      /^UniqueID:/ { u = $2 }
      END { out() }' \
  | sort -u | grep -E '^[0-9]+ /Users/[^/]+' | grep -vE '^[0-9]+ /Users/(Shared|Guest)$'
}
# console_user_home: prints "UID HOME" for the console user, with HOME read from the account record
# rather than assumed to be /Users/NAME, or nothing when nobody is logged in.
console_user_home(){
  local cu uid home
  cu="$(get_current_user)"
  [[ -z "$cu" || "$cu" == "loginwindow" ]] && return 0
  uid="$(id -u "$cu" 2>/dev/null)"
  home="$(dscl /Search -read "/Users/$cu" NFSHomeDirectory 2>/dev/null | awk '/^NFSHomeDirectory:/ { print $2; exit }')"
  [[ -n "$uid" && -n "$home" ]] && print -r -- "$uid $home"
}
expand_user_path(){
  local tpl="$1" home="$2"
  # Escape the %: in zsh a pattern starting with % is anchored to the end of the string,
  # so an unescaped %USER_HOME% never matches and no per-user file is removed.
  printf '%s' "${tpl//\%USER_HOME\%/$home}"
}

# killTree SIGNAL PID: signals PID's child processes first, then PID itself, so a command that
# runs through sudo or a shell does not leave its child running when it is stopped.
killTree(){
  local child
  for child in $(pgrep -P "$2" 2>/dev/null); do killTree "$1" "$child"; done
  kill -"$1" "$2" 2>/dev/null || true
}

# user_rm UID HOME PATH
# Removes PATH, a per-user file inside the home folder HOME of the account with uid UID. This
# script runs as root, and the user owns the folders in their home, so the user can replace a
# folder on the way (for example ~/Library/Application Support/App) with a link to a system
# folder; a plain rm -rf as root would then delete what sits behind the link. So before anything
# is removed:
#   - HOME must belong to UID, and UID must not be 0: the rm never runs as root;
#   - PATH must be written inside HOME, with no "." or ".." in it;
#   - no folder between HOME and PATH may be a link;
#   - the folder holding PATH, with links resolved, must still be inside HOME.
# The rm then runs as the owner of HOME, so a folder swapped after these checks can only lead to
# files that user could delete anyway. A file in the home that the user cannot delete (owned by
# root, for example) is left in place and logged. PATH itself may be a link: rm removes the link,
# not what it points to.
# The rm runs in the background with no input and is stopped after USER_RM_TIMEOUT seconds (60),
# so a hung network home or a stuck file system cannot hold up the policy.
user_rm(){
  local uid="$1" home="${2%/}" t="$3" rhome rparent owner ouid part p rest pid t0
  local limit="${USER_RM_TIMEOUT:-60}"
  [[ "$limit" == <-> && "$limit" -gt 0 ]] || limit=60
  [[ -e "$t" || -L "$t" ]] || return 0
  ouid="$(stat -f %u "$home" 2>/dev/null)"
  owner="$(stat -f %Su "$home" 2>/dev/null)"
  if [[ -z "$uid" || -z "$ouid" || -z "$owner" || "$ouid" != "$uid" || "$ouid" == 0 ]]; then
    printlog "skipped, home not owned by its user: $t ($home belongs to uid ${ouid:-unknown}, account uid ${uid:-unknown})" WARN
    return 0
  fi
  if [[ "$t" != "$home"/?* || "$t/" == */./* || "$t/" == */../* ]]; then
    printlog "skipped, path leaves the home folder: $t" WARN
    return 0
  fi
  rest="${${t:h}#$home}"
  p="$home"
  for part in "${(@s:/:)rest}"; do
    [[ -z "$part" ]] && continue
    p="$p/$part"
    if [[ -L "$p" ]]; then
      printlog "skipped, path leaves the home folder: $t ($p is a link)" WARN
      return 0
    fi
  done
  rhome="$(cd -P -- "$home" 2>/dev/null && pwd -P)"
  rparent="$(cd -P -- "${t:h}" 2>/dev/null && pwd -P)"
  if [[ -z "$rhome" || -z "$rparent" ]] || [[ "$rparent" != "$rhome" && "$rparent" != "$rhome"/* ]]; then
    printlog "skipped, path leaves the home folder: $t (its folder is ${rparent:-unreadable})" WARN
    return 0
  fi
  if [[ "${DEBUG:-0}" -eq 1 ]]; then
    printlog "[DEBUG] would remove as $owner: $t" DEBUG
    return 0
  fi
  printlog "Removing as $owner: $t" INFO
  /usr/bin/sudo -n -u "#$uid" /bin/rm -rf -- "$t" </dev/null &
  pid=$!
  t0=$SECONDS
  while kill -0 "$pid" 2>/dev/null; do
    if (( SECONDS - t0 >= limit )); then
      killTree TERM "$pid"
      sleep 2
      killTree KILL "$pid"
      wait "$pid" 2>/dev/null
      printlog "timed out, left in place: $t (rm as $owner still running after ${limit}s, stopped)" WARN
      return 0
    fi
    sleep 0.2
  done
  wait "$pid" 2>/dev/null
  if [[ -e "$t" || -L "$t" ]]; then
    printlog "$owner cannot remove all of $t (owned by another user, or locked); left in place" WARN
  fi
}

# --- Uninstall engine (runs after label case sets arrays) ---
do_uninstall(){
  # sanity for arrays
  (( ${#app_paths[@]} == 0 ))   && cleanupAndExit 1 "Label missing app_paths" ERROR
  [[ -z "${bundle_id:-}" ]]     && cleanupAndExit 1 "Label missing bundle_id" ERROR
  [[ -z "${app_name:-}" ]]      && app_name="$bundle_id"

  # optional notification at start
  [[ "${NOTIFY:-silent}" != "silent" && "${NOTIFY:-silent}" != "none" && "${NOTIFY:-silent}" != "error" ]] \
    && displaynotification "Removing ${app_name}…" "Uninstallomator"

  # Kill/quit processes (basic)
  blockingProcesses=("${blockingProcesses[@]:-}" "${app_name}")
  checkRunningProcesses

  # unload launch items
  local p
  for p in "${agents[@]:-}";  do [[ -n "$p" ]] && unload_launch "$p"; done
  for p in "${daemons[@]:-}"; do [[ -n "$p" ]] && unload_launch "$p"; done

  # app_paths may name a copy inside a home folder with %USER_HOME% (an app in ~/Applications,
  # for example a Setapp install). Each such entry is expanded for every user home when
  # USERSCOPE=1, or for the console user otherwise; with nobody logged in it is dropped.
  # ap_homes and ap_uids hold the home and its owner for each expanded entry (empty otherwise),
  # so that copy is removed as its owner through user_rm.
  # The user homes and their owners are read once, here, for every per-user entry.
  local -a ap_paths ap_homes ap_uids uh_homes uh_uids
  local ap ap_home ap_cu i k
  while read -r ap_cu ap_home; do
    uh_uids+=( "$ap_cu" ); uh_homes+=( "$ap_home" )
  done < <(if [[ "${USERSCOPE:-0}" -eq 1 ]]; then list_user_homes; else console_user_home; fi)
  for ap in "${app_paths[@]}"; do
    [[ -z "$ap" ]] && continue
    if [[ "$ap" != *%USER_HOME%* ]]; then
      ap_paths+=( "$ap" ); ap_homes+=( "" ); ap_uids+=( "" )
      continue
    fi
    for (( k = 1; k <= ${#uh_homes[@]}; k++ )); do
      ap_paths+=( "$(expand_user_path "$ap" "${uh_homes[$k]}")" ); ap_homes+=( "${uh_homes[$k]}" )
      ap_uids+=( "${uh_uids[$k]}" )
    done
  done

  # remove app bundles and system files
  found=0
  for p in "${ap_paths[@]}"; do [[ -n "$p" && -e "$p" ]] && found=1; done
  if (( found == 0 )); then cleanupAndExit 0 "$app_name not found in defined app paths" ERROR; fi
  for (( i = 1; i <= ${#ap_paths[@]}; i++ )); do
    p="${ap_paths[$i]}"
    [[ -z "$p" ]] && continue
    if [[ -n "${ap_homes[$i]}" && "$p" == "${ap_homes[$i]}"/* ]]; then
      user_rm "${ap_uids[$i]}" "${ap_homes[$i]}" "$p"
    else
      confirm_rm "$p"
    fi
  done
  for p in "${files[@]:-}";   do [[ -n "$p" ]] && confirm_rm "$p"; done

  # per-user files
  if [[ "${USERSCOPE:-0}" -eq 1 ]]; then
    local uh tgt uhuid
    for (( k = 1; k <= ${#uh_homes[@]}; k++ )); do
      uh="${uh_homes[$k]}"; uhuid="${uh_uids[$k]}"
      for p in "${user_files[@]:-}"; do
        [[ -z "$p" ]] && continue
        tgt="$(expand_user_path "$p" "$uh")"
        # A path in the home folder is removed as its owner, after the checks in user_rm.
        if [[ "$tgt" == "$uh"/* ]]; then user_rm "$uhuid" "$uh" "$tgt"; elif [[ -n "$tgt" ]]; then confirm_rm "$tgt"; fi
      done
    done
  else
   if (( ${#uh_homes[@]} == 0 )); then
     printlog "No user session (or no home found for it); skipping per-user file removals (USERSCOPE=0)" INFO
   else
     local cu_home="${uh_homes[1]}" tgt
     local cu_uid="${uh_uids[1]}"
    for p in "${user_files[@]:-}"; do
      [[ -z "$p" ]] && continue
      if [[ "$p" == %USER_HOME%* ]]; then
        tgt="$(expand_user_path "$p" "$cu_home")"
      elif [[ "$p" == ~/* ]]; then
        tgt="${p/#~\//$cu_home/}"
      else
        tgt="$p"
      fi
      # A path in the home folder is removed as its owner, after the checks in user_rm.
      if [[ "$tgt" == "$cu_home"/* ]]; then user_rm "$cu_uid" "$cu_home" "$tgt"; elif [[ -n "$tgt" ]]; then confirm_rm "$tgt"; fi
    done
   fi
  fi

  # receipts
  local id
  for id in "${pkgs[@]:-}"; do [[ -n "$id" ]] && forget_pkg "$id"; done

  # success check: nothing blocking remains and app bundles are gone (best-effort)
  local any_left=0
  for p in "${ap_paths[@]}"; do [[ -e "$p" ]] && any_left=1; done

  if (( any_left == 0 )); then
    [[ "${NOTIFY:-silent}" == "success" || "${NOTIFY:-silent}" == "all" ]] \
      && displaynotification "${app_name} removed." "Uninstall complete"
    printlog "Completed uninstall of ${app_name}" REQ
    return 0
  else
    [[ "$(get_current_user)" != "loginwindow" && "${NOTIFY:-silent}" == "all" ]] \
      && displaynotification "Failed to remove ${app_name}" "Uninstall failed"
    cleanupAndExit 1 "Some app bundles still present for ${app_name}" ERROR
  fi
}