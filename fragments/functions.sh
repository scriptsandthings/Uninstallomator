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

# --- Removal hooks (pre_remove / post_remove) ---
# A hook is a command a label or a policy wants run before the app is removed (pre_remove) or
# after it (post_remove). runHooks picks the commands for one phase, runHook runs one of them
# under a time limit, and hookGate decides whether it is safe to run as root at all.

# setHookOption KEY=value
# Stores a hook option exactly as typed. Other options are eval'd by the argument loop, which is
# fine for NOTIFY=all but would mangle a command: eval re-reads quotes, splits on spaces and runs
# anything after the first word. One pair of outer quotes is dropped, because admins write
# PRE_REMOVE="tool --flag" out of habit; a value that holds more quotes of the same kind keeps
# them all, so a command like "a b" "c" still means what was typed.
setHookOption(){
  local key="${1%%=*}" value="${1#*=}" inner
  inner="${value[2,-2]}"
  if [[ "$value" == \"*\" && "$inner" != *\"* ]] || [[ "$value" == \'*\' && "$inner" != *\'* ]]; then
    value="$inner"
  fi
  typeset -g "$key=$value"
  printlog "setting $key from argument" INFO
  printlog "$key: $value" DEBUG
}

# hookKillTree SIGNAL PID
# macOS has no `timeout` command, so a hook runs in the background and is stopped by hand when it
# runs too long. Killing only the background job would leave the vendor tool running if a shell or
# sudo sits in between, so the children are signalled first, then the job itself.
hookKillTree(){
  local child
  for child in $(pgrep -P "$2" 2>/dev/null); do hookKillTree "$1" "$child"; done
  kill -"$1" "$2" 2>/dev/null || true
}

# hookSigner PATH: prints the Team ID that signed PATH, or nothing if it is unsigned.
hookSigner(){
  codesign -dv "$1" 2>&1 | awk -F= '/^TeamIdentifier=/ { print $2; exit }'
}

# hookCheckOwner PATH: prints a reason and returns 1 if someone other than root or an
# administrator could have changed PATH. An administrator can become root anyway, so code they
# own gives nobody anything new; a standard user's file, or one anyone may write, does. For the
# same reason group write is allowed when the group is wheel (0) or admin (80): /Applications is
# root:admin 775.
hookCheckOwner(){
  local uid gid mode
  read -r uid gid mode <<< "$(stat -f '%u %g %Lp' "$1" 2>/dev/null)"
  if [[ -z "$uid" || -z "$gid" || -z "$mode" ]]; then
    print -r -- "cannot read the owner of $1"; return 1
  fi
  # A link's own mode means nothing (Linux shows every link as 777); only who owns it, and the
  # folders above it, decide who can change it.
  if [[ ! -L "$1" ]] && { (( (8#$mode & 8#002) != 0 )) || (( (8#$mode & 8#020) != 0 && gid != 0 && gid != 80 )); }; then
    print -r -- "$1 can be changed by its group or by anyone (mode $mode)"; return 1
  fi
  if (( uid != 0 )) && ! dsmemberutil checkmembership -u "$uid" -G admin 2>/dev/null | grep -q "is a member"; then
    print -r -- "$1 belongs to uid $uid, which is neither root nor an administrator"; return 1
  fi
  return 0
}

# hookCheckChain PATH: hookCheckOwner on PATH and on every folder above it up to and including /.
# Whoever can write to a folder can rename what is in it and put another in its place, so a
# root-owned tool under a folder a standard user owns, at any depth, is no safer than the user's
# own tool.
hookCheckChain(){
  local p="$1" why
  while :; do
    why="$(hookCheckOwner "$p")" || { print -r -- "$why"; return 1; }
    [[ "$p" == / || -z "$p" ]] && return 0
    p="${p:h}"
  done
}

# hookGateRefuse REASON: records why the gate refuses; the first reason found is the one logged.
hookGateRefuse(){
  [[ -n "$hookGateReason" ]] || hookGateReason="$1"
}

# hookGateFile WORD: a word that is not a program. If it names a file or folder (an argument such
# as the script in "/bin/sh /Library/x.sh", or a redirection's file), hookGate checks it like a
# program, since a root shell, cat or < reads it; if it names nothing yet, the nearest folder above
# it that exists is checked, since whoever can write there can put something at that name before
# the hook uses it. A hook runs from /, so a relative path is taken from /. A word with spaces is
# also checked piece by piece (code such as "system /Users/x/tool" names a file inside it), and one
# with quotes, ;, |, &, <, >, braces or parentheses that is not itself a path is refused: it is code
# for some interpreter (awk, perl -e, osascript -e) that the gate cannot read. ~ and $NAME are
# refused too: the gate cannot know what they will be. URLs and the sealed system folders are left
# alone.
hookGateFile(){
  local w="$1" p piece
  [[ "$w" == -*=* || "$w" =~ '^[A-Za-z_][A-Za-z0-9_]*=' ]] && w="${w#*=}"
  if [[ "$w" == \~* || "$w" =~ '\$[A-Za-z_{]|`' ]]; then
    hookGateRefuse "cannot tell which file '$w' is before it runs"; return 0
  fi
  [[ "$w" == */* ]] || return 0
  [[ "$w" =~ '^[a-z][a-z0-9+.-]*://[^[:space:]]*$' ]] && return 0
  [[ "$w" == /* ]] && p="${w:A}" || p="${${:-/$w}:A}"
  if [[ ! -e "$p" && ! -L "$p" ]]; then
    if [[ "$w" == *[\;\|\&\<\>\(\)\{\}\"\'$'\n']* ]]; then
      hookGateRefuse "cannot check the code in '$w'; put it in a script file"; return 0
    fi
    if [[ "$w" == *[[:space:]]* ]]; then
      for piece in ${=w}; do hookGateFile "$piece"; done
    fi
    while [[ ! -e "$p" && ! -L "$p" && "$p" != / ]]; do p="${p:h}"; done
  fi
  [[ "$p" == (/usr/bin|/bin|/usr/sbin|/sbin|/usr/libexec|/System|/dev)/* ]] && return 0
  files+=( "$p" )
}

# hookGateOption WRAPPER WORD: one option of a wrapper, read against a list per wrapper of the
# letters that take no value and those that take one. Anything else is refused: an option the gate
# does not know may take the program, or code, as its value (env -S, bash --rcfile). A value is
# checked as a file, attached (-ofoo) or as the next word (optval); a shell's c sets shellc.
hookGateOption(){
  local name="$1" w="$2" flags vals i
  [[ "$w" == -- ]] && return 0
  case "$name" in
    (sh|bash|zsh|ksh|dash|csh|tcsh)
      [[ "$w" == (--norc|--noprofile|--no-rcs|--no-globalrcs|--posix|--login|--noediting) ]] && return 0
      flags="efhilmnprsuvxc"; vals="oO" ;;
    (env) flags="i"; vals="u" ;;
    (nice) flags=""; vals="n" ;;
    (sudo) flags="EHn"; vals="ug" ;;
    (xargs) flags="0ortx"; vals="nLIJPsE" ;;
    (caffeinate) flags="dimsu"; vals="tw" ;;
    (arch)
      [[ "$w" == -(x86_64|x86_64h|arm64|arm64e|i386|32|64) ]] && return 0
      flags=""; vals="e" ;;
    (command) flags="pvV"; vals="" ;;
    (exec) flags="cl"; vals="a" ;;
    (*) flags=""; vals="" ;;
  esac
  if [[ "$w" != --* ]]; then
    for (( i = 2; i <= ${#w}; i++ )); do
      if [[ -n "$flags" && "$flags" == *"${w[i]}"* ]]; then
        [[ "$name" == (sh|bash|zsh|ksh|dash|csh|tcsh) && "${w[i]}" == c ]] && shellc=1
        continue
      fi
      if [[ -n "$vals" && "$vals" == *"${w[i]}"* ]]; then
        if (( i < ${#w} )); then hookGateFile "${w[i+1,-1]}"; else optval=1; fi
        return 0
      fi
      break
    done
    (( i > ${#w} )) && return 0
  fi
  hookGateRefuse "cannot tell what the option '$w' of $name takes"
}

# hookGateScan COMMAND: the parser half of hookGate. Adds to hookGate's exes the program each
# command starts, to its files every other word that names something on disk, and to its bundles
# every app bundle named anywhere. Wrappers (env, nohup, sudo, xargs, exec, command, a shell, ...)
# do not count as the program: the first word after them and their options is checked as one too.
# The commands inside <(...), >(...), =(...), $(...), `...` and after sh -c are scanned the same
# way. Here-documents, eval and cd are refused. A word the gate cannot follow sets hookGateReason.
hookGateScan(){
  local word exe bundle wrapper hop link n atcmd=1 wrap=0 shellc=0 optval=0 redir=0
  local -a words names
  words=( ${(z)1} )
  for word in "${words[@]}"; do
    # (z) gives each separator its own word; the word after one is a program again.
    if [[ "$word" == (';'|'&&'|'||'|'|'|'|&'|'&'|';|'|';&'|'&|'|'&!'|'('|'{'|'!'|if|then|elif|else|while|until|do|time|coproc|$'\n') ]]; then
      atcmd=1; wrap=0; shellc=0; optval=0; redir=0; continue
    fi
    if [[ "$word" =~ '^[0-9]*<<-?$' ]]; then
      hookGateRefuse "here-documents are not checked; put the code in a script file"; continue
    fi
    # A redirection operator: the word after it is a file (or a here-string), never a program.
    if [[ "$word" =~ '^[0-9]*(<|>|>>|<<<|<>|>&|<&|>\||>>\||&>|&>>)$' ]]; then
      redir=1; continue
    fi
    word="${(Q)word}"
    if (( redir || optval )); then
      redir=0; optval=0; hookGateFile "$word"; continue
    fi
    if (( shellc )); then
      shellc=0; atcmd=0; wrap=0; hookGateScan "$word"; continue
    fi
    if [[ "$word" == [\<\>=]\(*\) || ( "$word" == \$\(*\) && atcmd -eq 0 ) ]]; then
      hookGateScan "${word[3,-2]}"; continue
    fi
    if [[ "$word" == \`*\` && atcmd -eq 0 ]]; then
      hookGateScan "${word[2,-2]}"; continue
    fi
    if [[ "$word" == *.app/* ]]; then
      bundle="${word%%.app/*}.app"
      bundles+=( "/${bundle#*/}" )
    fi
    if (( ! atcmd )); then
      if [[ "$word" == *(\$\(|\`)* ]]; then
        hookGateRefuse "cannot check the command inside '$word'"; continue
      fi
      hookGateFile "$word"; continue
    fi
    # Leading VAR=value words set the environment; the program is the first word after them. The
    # value can name a file too (DYLD_INSERT_LIBRARIES=...).
    # (A regex: the glob form needs EXTENDED_GLOB, which this script never sets.)
    if [[ "$word" =~ '^[A-Za-z_][A-Za-z0-9_]*=' ]]; then
      hookGateFile "$word"; continue
    fi
    # A wrapper's options come before the program it runs. sh -c takes a command string.
    if (( wrap )) && [[ "$word" == -?* ]]; then
      hookGateOption "$wrapper" "$word"; continue
    fi
    atcmd=0; wrap=0
    if [[ "$word" == *[\$\`]* || "$word" == \~* ]]; then
      hookGateRefuse "cannot tell which program '$word' is before it runs"; exes+=( "?" ); continue
    fi
    # Builtins that run the next word (zsh finds them before any file of the same name).
    if [[ "$word" == (command|exec|builtin|noglob|nocorrect|-|source|.) ]]; then
      atcmd=1; wrap=1; wrapper="$word"; continue
    fi
    if [[ "$word" == eval ]]; then
      hookGateRefuse "eval hides which program runs; write the command out instead"; continue
    fi
    # A hook runs from /, and relative paths are checked from there; cd would move them.
    if [[ "$word" == (cd|chdir|pushd|popd) ]]; then
      hookGateRefuse "$word changes what relative paths name; use full paths instead"; continue
    fi
    if [[ "$word" == */* ]]; then
      exe="$word"
      [[ "$exe" == /* ]] || exe="/$exe"
    else
      exe="$(whence -p -- "$word")"
      if [[ -z "$exe" ]]; then
        [[ "$(whence -w -- "$word")" == *": "(builtin|reserved) ]] && continue
        hookGateRefuse "cannot find the program '$word'"; exes+=( "?" ); continue
      fi
    fi
    # A link is checked as well as what it points to, at every hop: whoever can change a link (or
    # a folder above it) can point it somewhere else, even when today it ends at a system program.
    # Each hop's name is kept too: the name a program is called by can decide what it does (/bin/sh
    # may be a link to busybox), so it is a wrapper if the called name, any link's target name or
    # the real program's name is one; the option list of the first name that matched is used.
    # (:a makes a path absolute without resolving links.)
    hop="${exe:a}"; names=( "${hop:t}" ); n=0
    while [[ -L "$hop" ]] && (( n++ < 16 )); do
      exes+=( "$hop" )
      link="$(readlink -- "$hop")"
      [[ "$link" == /* ]] || link="${hop:h}/$link"
      hop="${link:a}"; names+=( "${hop:t}" )
    done
    # :A makes the path absolute and resolves ".." and links: /usr/bin/../../Users/x is not a
    # system path.
    exe="${exe:A}"
    exes+=( "$exe" )
    [[ "$exe" == *.app/* ]] && bundles+=( "${exe%%.app/*}.app" )
    names+=( "${exe:t}" )
    for wrapper in "${names[@]}"; do
      [[ "$wrapper" == (sh|bash|zsh|ksh|dash|csh|tcsh|env|nohup|nice|sudo|xargs|caffeinate|arch) ]] && atcmd=1 && wrap=1 && break
    done
  done
}

# hookGate PHASE COMMAND ASUSER: returns 0 if COMMAND may run, 1 if not, with the reason in
# hookGateReason. (A global rather than stdout, so the gate can still write to the log.)
#
# Hooks run as root unless they ask for the console user, and the obvious hook calls a tool inside
# the app being removed. An app dragged into /Applications belongs to whoever copied it there, and
# that person can swap the tool for anything; a root hook would then run their code as root. So
# before a root hook runs, the gate looks at every program the command starts (the first word, the
# first word after each ; && || | and the like, and the program a wrapper such as env, sh or exec
# runs), and at every other word that names a file or folder on disk (hookGateScan):
#   - anything in /usr/bin, /bin, /usr/sbin, /sbin or /usr/libexec (and, for files, /System and
#     /dev): no check, those live on the sealed system volume;
#   - anything else: it and every folder above it up to / must not be writable by others (or by a
#     group other than wheel or admin) and must belong to root or an administrator;
#   - a program inside an app bundle, and any other app bundle named anywhere in the command
#     (so "/usr/bin/env /Applications/X.app/..." is caught too): in addition the bundle must pass
#     `codesign --verify --deep --strict` and be signed by the Team ID in HOOK_TEAM_ID or the
#     label's hook_team_id. No Team ID set means no root hook from a bundle.
# A shell builtin (echo, exit, ...) has no file to check. A program that cannot be found, one named
# through a variable or ~, a path built from a variable or ~, eval, cd, a here-document, a wrapper
# option the gate does not know, or interpreter code with a path in it (the gate cannot know what
# that will run) fails the check: the gate never falls back to running something as root.
# A hook that runs as the console user gains nothing it did not have, so only its signer is logged.
hookGate(){
  local phase="$1" cmd="$2" asuser="$3" exe bundle why team want="${HOOK_TEAM_ID:-${hook_team_id:-}}"
  local -a bundles exes files
  hookGateReason=""
  hookGateScan "$cmd"
  bundles=( "${(@u)bundles}" )

  if [[ "$asuser" == 1 ]]; then
    hookGateReason=""
    for bundle in "${bundles[@]}"; do
      printlog "$phase: $bundle is signed by Team ID $(hookSigner "$bundle" || true); not required, it runs as the user" INFO
    done
    return 0
  fi
  [[ -n "$hookGateReason" ]] && return 1

  for exe in "${exes[@]}" "${(@u)files}"; do
    [[ "$exe" == (/usr/bin|/bin|/usr/sbin|/sbin|/usr/libexec)/* ]] && continue
    why="$(hookCheckChain "$exe")" || { hookGateReason="$why"; return 1; }
  done
  for bundle in "${bundles[@]}"; do
    # Nothing at that path, not even a link: there is no code to run from it. A post_remove that
    # names the app it just removed, or a URL such as https://x.app/, lands here. A program inside
    # a missing bundle was already refused above, since its owner cannot be read.
    [[ ! -e "$bundle" && ! -L "$bundle" ]] && continue
    if [[ ! -d "$bundle" ]]; then
      hookGateReason="$bundle is not an app bundle on this Mac"; return 1
    fi
    why="$(hookCheckOwner "$bundle")" || { hookGateReason="$why"; return 1; }
    if [[ -z "$want" ]]; then
      hookGateReason="no hook_team_id or HOOK_TEAM_ID is set, so code inside $bundle will not run as root"; return 1
    fi
    if ! codesign --verify --deep --strict "$bundle" >/dev/null 2>&1; then
      hookGateReason="the signature of $bundle does not verify"; return 1
    fi
    team="$(hookSigner "$bundle")"
    if [[ "$team" != "$want" ]]; then
      hookGateReason="$bundle is signed by Team ID ${team:-none}, expected $want"; return 1
    fi
  done
  return 0
}

# runHook PHASE COMMAND ASUSER
# Runs one command with /bin/zsh --no-rcs -c, as root or as the console user, and returns its exit
# code: 124 if it was stopped at HOOK_TIMEOUT, 125 if it had to run as the user and nobody is
# logged in. When the gate refuses it, nothing runs, hookRefused is set and it returns 1.
# --no-rcs keeps root from reading a user's ~/.zshenv; /etc/zshenv is still read, as for any zsh.
# The user, the exit code and the seconds taken are logged. The command and the first 20 lines of
# output are logged at DEBUG only (LOGGING=DEBUG), since either can hold a licence key or a token.
runHook(){
  local phase="$1" cmd="$2" asuser="${3:-0}" who="root" uid limit="${HOOK_TIMEOUT:-120}"
  local out pid rc t0 elapsed timedout=0 line n=0 why
  if [[ "$limit" != <-> || "$limit" -eq 0 ]]; then
    printlog "$phase: HOOK_TIMEOUT '$limit' is not a whole number of seconds; using 120" WARN
    limit=120
  fi
  [[ "$asuser" == 1 ]] && who=$(get_current_user)
  if ! hookGate "$phase" "$cmd" "$asuser"; then
    why="$hookGateReason"
    # A refusal needs nothing to run, so a DEBUG run reports it and then acts on it like a real
    # run would: with PRE_REMOVE_REQUIRED=1 the dry run ends with the same exit 12.
    if [[ "${DEBUG:-0}" -eq 1 ]]; then
      printlog "[DEBUG] would refuse $phase: $why; not run" DEBUG
    else
      printlog "$phase: refused, $why; not run" WARN
    fi
    printlog "$phase command: $cmd" DEBUG
    hookRefused=1
    return 1
  fi
  if [[ "${DEBUG:-0}" -eq 1 ]]; then
    printlog "[DEBUG] would run $phase as ${who:-no user} (timeout ${limit}s): $cmd" DEBUG
    return 0
  fi
  if [[ "$asuser" == 1 && ( -z "$who" || "$who" == "loginwindow" ) ]]; then
    printlog "$phase: nobody is logged in, so it cannot run as the user; not run" WARN
    return 125
  fi
  printlog "$phase: running as $who (timeout ${limit}s)" INFO
  printlog "$phase command: $cmd" DEBUG
  out=$(mktemp "${TMPDIR:-/private/tmp}/uninstallomator-hook.XXXXXX" 2>/dev/null) || out=/dev/null
  t0=$(date +%s)
  # Background job plus a polling loop is the timeout: stdin is closed so a tool that asks a
  # question fails instead of waiting for an answer nobody can give. The hook runs from /, where
  # hookGate looked for its relative paths.
  if [[ "$asuser" == 1 ]]; then
    uid=$(id -u "$who")
    { cd / && exec launchctl asuser "$uid" sudo -u "$who" /bin/zsh --no-rcs -c "$cmd" } </dev/null >"$out" 2>&1 &
  else
    { cd / && exec /bin/zsh --no-rcs -c "$cmd" } </dev/null >"$out" 2>&1 &
  fi
  pid=$!
  while kill -0 "$pid" 2>/dev/null; do
    if (( $(date +%s) - t0 >= limit )); then
      timedout=1
      printlog "$phase: still running after ${limit}s; stopping it" WARN
      hookKillTree TERM "$pid"
      sleep 2
      hookKillTree KILL "$pid"
      break
    fi
    sleep 1
  done
  wait "$pid" 2>/dev/null
  rc=$?
  (( timedout )) && rc=124
  elapsed=$(( $(date +%s) - t0 ))
  if [[ -s "$out" ]]; then
    while IFS= read -r line; do
      if (( ++n > 20 )); then printlog "$phase: output cut at 20 lines" DEBUG; break; fi
      printlog "$phase output: $line" DEBUG
    done < "$out"
  fi
  [[ "$out" != /dev/null ]] && rm -f -- "$out"
  if (( timedout )); then
    printlog "$phase: stopped after ${limit}s; exit $rc, ${elapsed}s, as $who" WARN
  elif (( rc == 0 )); then
    printlog "$phase: exit 0, ${elapsed}s, as $who" INFO
  else
    printlog "$phase: exit $rc, ${elapsed}s, as $who" WARN
  fi
  return $rc
}

# runHooks PHASE (pre_remove or post_remove)
# Chooses the commands for the phase (the option, else the label), skips
# pre_remove when none of the label's app_paths exists (there is nothing to deactivate, and the
# run is about to end with "not found"), and runs them in order.
# Returns 0 if all ran cleanly, 1 if one failed, 2 if the gate refused one. With
# PRE_REMOVE_REQUIRED=1 a pre_remove stops at the first problem and the caller ends the run with
# exit 12 (the log says which of the two it was).
runHooks(){
  local phase="$1" opt asuser c failed=0
  local -a cmds sysext
  hookRefused=0
  if [[ "$phase" == "pre_remove" ]]; then
    opt="${PRE_REMOVE:-}"
    asuser="${PRE_REMOVE_AS_USER:-${pre_remove_as_user:-0}}"; cmds=("${pre_remove[@]}")
  else
    opt="${POST_REMOVE:-}"
    asuser="${POST_REMOVE_AS_USER:-${post_remove_as_user:-0}}"; cmds=("${post_remove[@]}")
  fi
  if [[ -n "$opt" ]]; then
    (( ${#cmds[@]} > 0 )) && printlog "$phase: the command from the option ${(U)phase} replaces the label's $phase" INFO
    cmds=("$opt")
  fi
  cmds=("${(@)cmds:#}")
  (( ${#cmds[@]} == 0 )) && return 0
  if [[ "$phase" == "pre_remove" ]]; then
    installedAppPaths
    if (( ${#reply[@]} == 0 )); then
      printlog "$phase: skipped, $app_name is not installed" INFO
      return 0
    fi
    # A system extension stays loaded after its app is deleted, and deactivating it is the usual
    # job of a vendor's pre_remove. So unless PRE_REMOVE_REQUIRED says otherwise, a pre_remove that
    # fails for such an app stops the run, instead of leaving it half uninstalled.
    if [[ -z "${PRE_REMOVE_REQUIRED:-}" ]]; then
      PRE_REMOVE_REQUIRED=0
      for c in "${reply[@]}"; do
        sysext=( "$c"/Contents/Library/SystemExtensions/*.systemextension(N) )
        (( ${#sysext[@]} )) || continue
        PRE_REMOVE_REQUIRED=1
        printlog "$phase: $c holds a system extension, so a failed pre_remove stops the run (PRE_REMOVE_REQUIRED=0 to go on anyway)" INFO
        break
      done
    fi
  fi
  for c in "${cmds[@]}"; do
    runHook "$phase" "$c" "$asuser" || failed=1
    (( failed )) && [[ "$phase" == "pre_remove" && "${PRE_REMOVE_REQUIRED:-0}" == 1 ]] && break
  done
  (( hookRefused )) && return 2
  return $failed
}

# --- Userscope helpers ---
list_user_homes(){
  dscl . -readall /Users NFSHomeDirectory UniqueID 2>/dev/null \
  | awk '/^NFSHomeDirectory:/{h=$2} /^UniqueID:/{uid=$2; if (uid>=500) print h}' \
  | sort -u | grep -E '^/Users/[^/]+' | grep -vE '^/Users/(Shared|Guest)$'
}
expand_user_path(){
  local tpl="$1" home="$2"
  # Escape the %: in zsh a pattern starting with % is anchored to the end of the string,
  # so an unescaped %USER_HOME% never matches and no per-user file is removed.
  printf '%s' "${tpl//\%USER_HOME\%/$home}"
}
# installedAppPaths: sets reply to those of the label's app_paths that exist. An entry with
# %USER_HOME% is looked for in every user home with USERSCOPE=1, or in the console user's home
# otherwise (the homes user_files are removed from), so a copy in ~/Applications counts as
# installed. Used to decide whether pre_remove runs; nothing is removed from here.
installedAppPaths(){
  local p h cu
  local -a homes
  reply=()
  if [[ "${USERSCOPE:-0}" -eq 1 ]]; then
    homes=( ${(f)"$(list_user_homes)"} )
  else
    cu="$(get_current_user)"
    [[ -n "$cu" && "$cu" != "loginwindow" ]] && homes=( "/Users/$cu" )
  fi
  for p in "${app_paths[@]}"; do
    [[ -z "$p" ]] && continue
    if [[ "$p" == *%USER_HOME%* ]]; then
      for h in "${homes[@]}"; do
        h="$(expand_user_path "$p" "$h")"
        [[ -e "$h" ]] && reply+=( "$h" )
      done
    elif [[ -e "$p" ]]; then
      reply+=( "$p" )
    fi
  done
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

  # pre_remove hooks: only if the app is installed, and before anything is quit or removed, so a
  # vendor tool can still find the app and its licence. With PRE_REMOVE_REQUIRED=1 a failure, or a
  # refusal by the safety check, stops the run here with exit 12 and nothing removed.
  # hadApp remembers that the app was there, in case a vendor uninstaller in pre_remove removes it.
  local hadApp=0
  installedAppPaths
  (( ${#reply[@]} )) && hadApp=1
  runHooks pre_remove
  local preResult=$?
  if [[ "${PRE_REMOVE_REQUIRED:-0}" == 1 ]]; then
    (( preResult == 2 )) && cleanupAndExit 12 "pre_remove was refused by the safety check and PRE_REMOVE_REQUIRED=1; nothing was removed" ERROR
    (( preResult == 1 )) && cleanupAndExit 12 "pre_remove failed and PRE_REMOVE_REQUIRED=1; nothing was removed" ERROR
  fi

  # Kill/quit processes (basic)
  blockingProcesses=("${blockingProcesses[@]:-}" "${app_name}")
  checkRunningProcesses

  # unload launch items
  local p
  for p in "${agents[@]:-}";  do [[ -n "$p" ]] && unload_launch "$p"; done
  for p in "${daemons[@]:-}"; do [[ -n "$p" ]] && unload_launch "$p"; done

  # remove app bundles and system files
  found=0
  for p in "${app_paths[@]}"; do [[ -n "$p" && -e "$p" ]] && found=1; done
  if (( found == 0 )); then
    # A vendor uninstaller run by pre_remove may have removed the app itself. The rest of the label
    # still runs then, so the files, receipts and per-user data the vendor tool left are removed too.
    (( hadApp )) || cleanupAndExit 0 "$app_name not found in defined app paths" ERROR
    printlog "pre_remove removed ${app_name} itself; removing what is left" INFO
  fi
  for p in "${app_paths[@]}"; do [[ -n "$p" ]] && confirm_rm "$p"; done
  for p in "${files[@]:-}";   do [[ -n "$p" ]] && confirm_rm "$p"; done

  # per-user files
  if [[ "${USERSCOPE:-0}" -eq 1 ]]; then
    local uh tgt
    while IFS= read -r uh; do
      for p in "${user_files[@]:-}"; do
        [[ -z "$p" ]] && continue
        tgt="$(expand_user_path "$p" "$uh")"
        [[ -n "$tgt" ]] && confirm_rm "$tgt"
      done
    done < <(list_user_homes)
  else
    local cu_name; cu_name="$(get_current_user)"
   if [[ "$cu_name" == "loginwindow" || -z "$cu_name" ]]; then
     printlog "No user session; skipping per-user file removals (USERSCOPE=0)" INFO
   else
     local cu_home="/Users/$cu_name" tgt
    for p in "${user_files[@]:-}"; do
      [[ -z "$p" ]] && continue
      if [[ "$p" == %USER_HOME%* ]]; then
        tgt="$(expand_user_path "$p" "$cu_home")"
      elif [[ "$p" == ~/* ]]; then
        tgt="${p/#~\//$cu_home/}"
      else
        tgt="$p"
      fi
      [[ -n "$tgt" ]] && confirm_rm "$tgt"
    done
   fi
  fi

  # receipts
  local id
  for id in "${pkgs[@]:-}"; do [[ -n "$id" ]] && forget_pkg "$id"; done

  # post_remove hooks: after removal. The files are gone whatever the hook does, so its result is
  # logged and never changes the exit code.
  runHooks post_remove || printlog "post_remove did not succeed; the uninstall result is unchanged" WARN

  # success check: nothing blocking remains and app bundles are gone (best-effort)
  local any_left=0
  for p in "${app_paths[@]}"; do [[ -e "$p" ]] && any_left=1; done

  # A DEBUG run removes nothing, so the bundles are always still there. Without this the dry run
  # ended with exit 1 "Some app bundles still present" even when a real run would have worked.
  if [[ "${DEBUG:-0}" -eq 1 ]]; then
    printlog "DEBUG: dry run for ${app_name} finished; nothing was removed" REQ
    return 0
  fi
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
