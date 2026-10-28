#!/bin/bash
# Removal hook tests for Uninstallomator (pre_remove / post_remove).
#
# Runs ONLY inside a throwaway Linux container: it writes stubs over macOS tools in /usr/bin,
# creates users and fake apps under /Applications, and runs the script as root. It refuses to
# start anywhere else. Never run it on a Mac.
#
# Stubs (each is a few lines of sh, written below; they stand in for the macOS tools so the
# engine's own code paths run unchanged):
#   sw_vers       prints 15.0 (the engine refuses to run below 10.14)
#   scutil        prints "Name : <user>" from /stub/console; write loginwindow there for "nobody"
#   dscl          lists one home, /Users/testuser, uid 501
#   pkgutil, defaults   do nothing
#   launchctl     "asuser UID cmd..." runs cmd...; anything else succeeds. sudo is the real one.
#   codesign      --verify fails if the bundle holds a file .badsig; -dv prints
#                 TeamIdentifier=<contents of the bundle's .teamid>, or "not set"
#   stat          -f '%u %g %Lp' is answered with busybox stat -c '%u %g %a' (uid, gid, octal mode)
#   dsmemberutil  "checkmembership -u UID -G admin" is a member if UID is in /stub/admin-uids
# Users: testuser (501, standard), adminuser (502, listed in /stub/admin-uids).
#
#   docker run --rm -v "$PWD:/w/src:ro" alpine:3 sh -c \
#     'apk add --no-cache bash zsh procps sudo coreutils shadow >/dev/null &&
#      bash /w/src/tests/hooks/run.sh /w/src/Uninstallomator.sh'
#
# Exit status: 0 if every check passed, 1 otherwise.

# shellcheck disable=SC2016  # the stubs' $1 and $(...) are meant for the stub, not for this shell
SCRIPT="${1:?usage: run.sh path/to/Uninstallomator.sh}"
HERE="$(cd "$(dirname "$0")" && pwd)"

if [ ! -f /.dockerenv ] && [ "${UNINST_HOOK_TEST_CONTAINER:-0}" != 1 ]; then
  echo "refusing: not inside a container (no /.dockerenv)" >&2
  exit 2
fi
[ "$(uname -s)" = Linux ] || { echo "refusing: not Linux" >&2; exit 2; }

# --- stubs for the macOS tools the engine calls ---
mkdir -p /private/var/log /private/tmp /Applications /w/out /stub
chmod 755 /w/out
id testuser >/dev/null 2>&1 || useradd -m -u 501 -d /Users/testuser testuser
echo testuser > /stub/console
stub() { printf '#!/bin/sh\n%s\n' "$2" > "/usr/bin/$1"; chmod 755 "/usr/bin/$1"; }
stub sw_vers 'case "$1" in -buildVersion) echo 24A335;; *) echo 15.0;; esac'
stub scutil 'cat >/dev/null; echo "  Name : $(cat /stub/console)"'
stub dscl 'printf "NFSHomeDirectory: /Users/testuser\nUniqueID: 501\n"'
stub pkgutil 'exit 0'
stub defaults 'exit 1'
stub launchctl 'if [ "$1" = asuser ]; then shift 2; exec "$@"; fi; exit 0'
stub codesign 'case "$1" in
  --verify) [ -e "$4/.badsig" ] && { echo "$4: invalid signature" >&2; exit 1; }; exit 0 ;;
  -dv) if [ -f "$2/.teamid" ]; then echo "TeamIdentifier=$(cat "$2/.teamid")" >&2; else echo "TeamIdentifier=not set" >&2; fi ;;
esac'
stub stat 'exec busybox stat -c "%u %g %a" "$3"'
stub dsmemberutil 'if grep -qx "$3" /stub/admin-uids; then echo "user is a member of the group"; else echo "user is not a member of the group"; fi'
id adminuser >/dev/null 2>&1 || useradd -m -u 502 -d /Users/adminuser adminuser
echo 502 > /stub/admin-uids

# --- test copy of the script: the fixture arms go after the valuesfromarguments arm ---
T=/w/Uninstallomator-test.sh
awk -v fx="$HERE/fixtures.sh" '
  { print }
  $0 == "valuesfromarguments)" { inarm = 1 }
  inarm && $0 ~ /^[[:space:]]*;;[[:space:]]*$/ { while ((getline l < fx) > 0) print l; inarm = 0 }
' "$SCRIPT" > "$T"
# Upstream's own build ships with DEBUG=1 and NOTIFY=success as defaults. The tests need real runs,
# and a notification has no one to show it to in a container (it only costs time), so both are reset.
sed -i -e 's/^DEBUG=1$/DEBUG=0/' -e 's/^NOTIFY=success$/NOTIFY=silent/' "$T"
zsh -n "$T" || { echo "test copy does not parse" >&2; exit 1; }

PASS=0; FAIL=0; RC=0; ELAPSED=0; LOG=""
reset_state() {
  rm -rf /w/out/* /Applications/HookTest.app /Applications/AutoMounter.app /Applications/Gate.app /usr/local/bin/hooktool
  mkdir -p /w/out/u; chmod 777 /w/out/u
  mkdir -p /Applications/HookTest.app/Contents/MacOS
  echo testuser > /stub/console
}
# fake_bundle PATH TEAMID: a root-owned, 755 app bundle whose tool records who ran it and with what
fake_bundle() {
  local exe="$1/Contents/MacOS/${3:-tool}"
  mkdir -p "$(dirname "$exe")"
  printf '#!/bin/sh\necho "$(id -un) $*" > /w/out/u/%s.ran\necho "tool says hello"\n' "$(basename "$exe")" > "$exe"
  echo "$2" > "$1/.teamid"
  chown -R root:root "$1"; chmod -R 755 "$1"
}
# fake_tool PATH MODE OWNER: a tool outside any bundle
fake_tool() {
  mkdir -p "$(dirname "$1")"
  printf '#!/bin/sh\necho "$(id -un) $*" > /w/out/u/hooktool.ran\n' > "$1"
  chown "$3" "$1"; chmod "$2" "$1"
}
# run LABEL [KEY=value ...]: the Jamf form ($1 "/", then computer and user names, then the label)
run() {
  local t0; t0=$(date +%s)
  LOG=$(cd /w && zsh --no-rcs "$T" / testmac testuser "$@" 2>&1); RC=$?
  ELAPSED=$(( $(date +%s) - t0 ))
}
# runj LABEL P5 P6 P7 P8 P9 P10 P11: every Jamf parameter slot given, empty ones as ""
runj() { run "$@"; }
# runcli LABEL ARGS...: called from a shell, not from Jamf (no "/" and no parameter slots)
runcli() {
  local t0; t0=$(date +%s)
  LOG=$(cd /w && zsh --no-rcs "$T" "$@" 2>&1); RC=$?
  ELAPSED=$(( $(date +%s) - t0 ))
}
check() { # check CASE DESCRIPTION -- test command...
  local c="$1" d="$2"; shift 3
  if "$@"; then PASS=$((PASS + 1)); printf 'PASS\t%s\t%s\n' "$c" "$d"
  else FAIL=$((FAIL + 1)); printf 'FAIL\t%s\t%s\n' "$c" "$d"; printf '%s\n' "$LOG" | grep -E ' : (DEBUG|INFO|WARN|ERROR|REQ) : ' | sed 's/^/    | /' | tail -40; fi
}
has() { printf '%s\n' "$LOG" | grep -qF -- "$1"; }
hasnt() { ! has "$1"; }
gone() { [ ! -e "$1" ]; }
no_proc() { ! pgrep -f "^$1" >/dev/null; }  # anchored, so it cannot match this shell's own command line

# 0. control: no_proc must see a live process, or the timeout checks below prove nothing
sleep 33 & CTL=$!
check control "no_proc detects a running sleep" -- sh -c "! pgrep -f '^sleep 33' >/dev/null && exit 1; exit 0"
check control "no_proc reports it" -- eval '! no_proc "sleep 33"'
kill "$CTL" 2>/dev/null; wait "$CTL" 2>/dev/null

# 1. pre ok: both pre commands run in order, output is logged, removal and post_remove follow
reset_state; run hooktest-ok
check pre-ok "exit 0" -- [ "$RC" -eq 0 ]
check pre-ok "pre_remove ran" -- [ -f /w/out/pre.ok ]
check pre-ok "user, exit, duration logged" -- has "pre_remove: exit 0, "
check pre-ok "logged as root" -- has "pre_remove: running as root (timeout 120s)"
check pre-ok "command not logged at INFO" -- hasnt "touch /w/out/pre.ok"
check pre-ok "output not logged at INFO" -- hasnt "second line"
check pre-ok "app removed" -- gone /Applications/HookTest.app
check pre-ok "post_remove ran" -- [ -f /w/out/post.ok ]
check pre-ok "no 1 s wait per hook beyond poll" -- [ "$ELAPSED" -lt 15 ]
reset_state; run hooktest-ok LOGGING=DEBUG
check pre-ok-debuglog "LOGGING=DEBUG: command logged" -- has "pre_remove command: touch /w/out/pre.ok"
check pre-ok-debuglog "LOGGING=DEBUG: output logged" -- has "pre_remove output: second line"
check pre-ok-debuglog "LOGGING=DEBUG is still a real run" -- [ -f /w/out/pre.ok ]

# 2. pre fails: warning, removal goes on
reset_state; run hooktest-prefail
check pre-fail "exit 0" -- [ "$RC" -eq 0 ]
check pre-fail "exit 3 logged as WARN" -- has "WARN : hooktest-prefail : pre_remove: exit 3"
check pre-fail "app removed anyway" -- gone /Applications/HookTest.app
check pre-fail "post_remove ran" -- [ -f /w/out/post.ok ]

# 3. pre fails with PRE_REMOVE_REQUIRED=1: exit 12, nothing removed, no post
reset_state; run hooktest-prefail PRE_REMOVE_REQUIRED=1
check pre-required "exit 12" -- [ "$RC" -eq 12 ]
check pre-required "app still present" -- [ -d /Applications/HookTest.app ]
check pre-required "post_remove not run" -- [ ! -f /w/out/post.ok ]
check pre-required "reason logged" -- has "pre_remove failed and PRE_REMOVE_REQUIRED=1; nothing was removed"

# 3b. pre fails for an app that holds a system extension: stops like PRE_REMOVE_REQUIRED=1, unless
# PRE_REMOVE_REQUIRED=0 is given
reset_state; mkdir -p /Applications/HookTest.app/Contents/Library/SystemExtensions/x.systemextension
run hooktest-prefail
check sysext "exit 12" -- [ "$RC" -eq 12 ]
check sysext "app still present" -- [ -d /Applications/HookTest.app ]
check sysext "post_remove not run" -- [ ! -f /w/out/post.ok ]
check sysext "reason logged" -- has "holds a system extension, so a failed pre_remove stops the run"
reset_state; mkdir -p /Applications/HookTest.app/Contents/Library/SystemExtensions/x.systemextension
run hooktest-prefail PRE_REMOVE_REQUIRED=0
check sysext-forced "PRE_REMOVE_REQUIRED=0: exit 0" -- [ "$RC" -eq 0 ]
check sysext-forced "app removed" -- gone /Applications/HookTest.app
reset_state; mkdir -p /Applications/HookTest.app/Contents/Library/SystemExtensions/x.systemextension
run hooktest-ok
check sysext-ok "a pre_remove that works: removal goes on" -- gone /Applications/HookTest.app

# 4. post fails: logged, result unchanged
reset_state; run hooktest-postfail
check post-fail "exit 0" -- [ "$RC" -eq 0 ]
check post-fail "exit 5 logged" -- has "post_remove: exit 5"
check post-fail "result unchanged message" -- has "post_remove did not succeed; the uninstall result is unchanged"
check post-fail "app removed" -- gone /Applications/HookTest.app

# 5. timeout: a hung hook is stopped with its children, removal goes on
reset_state; run hooktest-hang HOOK_TIMEOUT=3
check timeout "exit 0" -- [ "$RC" -eq 0 ]
check timeout "stopped well before the hook's 30 s" -- [ "$ELAPSED" -lt 15 ]
check timeout "timeout logged" -- has "pre_remove: stopped after 3s; exit 124"
check timeout "hook did not finish" -- [ ! -f /w/out/hang.done ]
check timeout "no sleep left running" -- no_proc "sleep 30"
check timeout "app removed" -- gone /Applications/HookTest.app

# 5b. timeout with PRE_REMOVE_REQUIRED=1
reset_state; run hooktest-hang HOOK_TIMEOUT=2 PRE_REMOVE_REQUIRED=1
check timeout-required "exit 12" -- [ "$RC" -eq 12 ]
check timeout-required "app still present" -- [ -d /Applications/HookTest.app ]

# 5c. timeout of a hook run as the user (launchctl asuser + sudo chain)
reset_state; run hooktest-userhang HOOK_TIMEOUT=3
check timeout-user "stopped" -- [ "$ELAPSED" -lt 15 ]
check timeout-user "no sleep left running" -- no_proc "sleep 31"
sleep 1
check timeout-user "hook did not finish" -- [ ! -f /w/out/u/hang.done ]

# 5d. a bad HOOK_TIMEOUT falls back to 120
reset_state; run hooktest-ok HOOK_TIMEOUT=abc
check timeout-bad "warned and used 120" -- has "HOOK_TIMEOUT 'abc' is not a whole number of seconds; using 120"
check timeout-bad "hooks still ran" -- [ -f /w/out/pre.ok ]

# 6. DEBUG=1 prints the hooks and runs nothing
reset_state; run hooktest-ok DEBUG=1
check debug "exit 0 (a dry run that would have worked; it used to be exit 1)" -- [ "$RC" -eq 0 ]
check debug "dry run end logged" -- has "DEBUG: dry run for HookTest finished; nothing was removed"
check debug "would-run line for pre" -- has "[DEBUG] would run pre_remove as root (timeout 120s): touch /w/out/pre.ok"
check debug "would-run line for post" -- has "[DEBUG] would run post_remove as root (timeout 120s): touch /w/out/post.ok"
check debug "pre not run" -- [ ! -f /w/out/pre.ok ]
check debug "post not run" -- [ ! -f /w/out/post.ok ]
check debug "app kept" -- [ -d /Applications/HookTest.app ]

# 6b. the DEBUG exit fix on its own: a label with no hooks, dry run, exit 0 and nothing removed
reset_state; run valuesfromarguments DEBUG=1 app_name=HookTest bundle_id=test.hooktest 'app_paths=(/Applications/HookTest.app)'
check debug-nohooks "DEBUG dry run of a label without hooks: exit 0" -- [ "$RC" -eq 0 ]
check debug-nohooks "would-remove line logged" -- has "[DEBUG] would remove: /Applications/HookTest.app"
check debug-nohooks "app kept" -- [ -d /Applications/HookTest.app ]
check debug-nohooks "no 'still present' error" -- hasnt "Some app bundles still present"

# 7. options override the label
reset_state; run hooktest-ok 'PRE_REMOVE="touch /w/out/opt.ok"'
check option "option command ran" -- [ -f /w/out/opt.ok ]
check option "label pre_remove did not" -- [ ! -f /w/out/pre.ok ]
check option "override logged" -- has "pre_remove: the command from the option PRE_REMOVE replaces the label's pre_remove"
check option "label post_remove kept" -- [ -f /w/out/post.ok ]
reset_state; run hooktest-ok 'PRE_REMOVE="id -un > /w/out/u/user.out"' PRE_REMOVE_AS_USER=1
check option-user "PRE_REMOVE_AS_USER=1 ran as the user" -- [ "$(cat /w/out/u/user.out 2>/dev/null)" = testuser ]
reset_state; chmod 755 /w/out/u; run hooktest-user PRE_REMOVE_AS_USER=0
check option-root "PRE_REMOVE_AS_USER=0 overrides the label's 1" -- [ "$(cat /w/out/u/user.out 2>/dev/null)" = root ]
reset_state; run hooktest-postfail 'POST_REMOVE="touch /w/out/post.ok"'
check option-post "POST_REMOVE replaced a failing post_remove" -- [ -f /w/out/post.ok ]
check option-post "no post failure logged" -- hasnt "post_remove did not succeed"

# 8. app absent: pre skipped, post never reached
reset_state; run hooktest-absent
check absent "exit 0" -- [ "$RC" -eq 0 ]
check absent "pre skipped and logged" -- has "pre_remove: skipped, NotThere is not installed"
check absent "pre not run" -- [ ! -f /w/out/pre.ok ]
check absent "post not run" -- [ ! -f /w/out/post.ok ]

# 8b. an app installed only in a home folder (%USER_HOME% in app_paths) counts as installed
reset_state; mkdir -p /Users/testuser/Applications/HookTest.app
run hooktest-userhome
check userhome "pre_remove ran for the console user's copy" -- [ -f /w/out/pre.ok ]
check userhome "not skipped as 'not installed'" -- hasnt "pre_remove: skipped"
reset_state; echo loginwindow > /stub/console; mkdir -p /Users/testuser/Applications/HookTest.app
run hooktest-userhome USERSCOPE=1
check userhome-all "USERSCOPE=1, nobody logged in: every home is looked in" -- [ -f /w/out/pre.ok ]
reset_state; rm -rf /Users/testuser/Applications/HookTest.app
run hooktest-userhome
check userhome-absent "no copy in any home: skipped" -- has "pre_remove: skipped, HookTest is not installed"
check userhome-absent "not run" -- [ ! -f /w/out/pre.ok ]
rm -rf /Users/testuser/Applications

# 9. as the console user
reset_state; run hooktest-user
check as-user "ran as testuser" -- [ "$(cat /w/out/u/user.out 2>/dev/null)" = testuser ]
check as-user "logged as testuser" -- has "pre_remove: exit 0, "
check as-user "user named in log" -- has "as testuser"
echo loginwindow > /stub/console; rm -rf /w/out/u/*; mkdir -p /Applications/HookTest.app
run hooktest-user
check no-user "nobody logged in: warned, not run" -- has "nobody is logged in, so it cannot run as the user"
check no-user "removal went on" -- [ "$RC" -eq 0 ]
echo loginwindow > /stub/console; mkdir -p /Applications/HookTest.app
run hooktest-user PRE_REMOVE_REQUIRED=1
check no-user-required "exit 12" -- [ "$RC" -eq 12 ]

# 10. a single string instead of an array
reset_state; run hooktest-scalar
check scalar "single-string pre_remove ran" -- [ -f /w/out/scalar.ok ]

# 11. the real automounter label with a fake AutoMounter bundle signed by the vendor's Team ID
# (only in a build whose automounter label has the hook; upstream's label does not)
if grep -q 'hook_team_id="UKWABN4MGL"' "$T"; then
  reset_state; fake_bundle /Applications/AutoMounter.app UKWABN4MGL AutoMounter
  run automounter LOGGING=DEBUG
  check automounter "exit 0" -- [ "$RC" -eq 0 ]
  check automounter "ran --deactivate as root" -- [ "$(cat /w/out/u/AutoMounter.ran 2>/dev/null)" = "root --deactivate" ]
  check automounter "tool output logged" -- has "pre_remove output: tool says hello"
  check automounter "app removed" -- gone /Applications/AutoMounter.app
  reset_state; fake_bundle /Applications/AutoMounter.app ZZZZZ99999 AutoMounter
  run automounter
  check automounter-imposter "another Team ID: refused" -- has "is signed by Team ID ZZZZZ99999, expected UKWABN4MGL"
  check automounter-imposter "not run" -- [ ! -f /w/out/u/AutoMounter.ran ]
else
  echo "SKIP	automounter	this build's automounter label has no hook"
fi

# 12. labels without hooks are unchanged: no hook lines at all
reset_state; run valuesfromarguments app_name=HookTest bundle_id=test.hooktest 'app_paths=(/Applications/HookTest.app)'
check no-hooks "exit 0" -- [ "$RC" -eq 0 ]
check no-hooks "no hook lines logged" -- hasnt "_remove"
check no-hooks "app removed" -- gone /Applications/HookTest.app

# 13. Jamf parameters 10 and 11: hook commands only with PRE_REMOVE= / POST_REMOVE=, empty slots
# skipped, every other KEY=value an option as upstream reads it
reset_state; runj hooktest-ok "" "" "" "" "" "PRE_REMOVE=touch /w/out/p10.ok" "POST_REMOVE=touch /w/out/p11.ok"
check param-slots "6 to 9 empty: parameter 10 ran" -- [ -f /w/out/p10.ok ]
check param-slots "parameter 11 ran" -- [ -f /w/out/p11.ok ]
check param-slots "they replaced the label's hooks" -- sh -c '[ ! -f /w/out/pre.ok ] && [ ! -f /w/out/post.ok ]'
check param-slots "source logged" -- has "pre_remove: the command from the option PRE_REMOVE replaces the label's pre_remove"
reset_state; runj hooktest-ok "" "" "" "" "" 'PRE_REMOVE=touch "/w/out/with space.ok"' ""
check param-spaces "a quoted path with a space" -- [ -f "/w/out/with space.ok" ]
check param-spaces "only 11 empty: label post_remove kept" -- [ -f /w/out/post.ok ]
reset_state; runj hooktest-ok "" "" "" "" "" "PRE_REMOVE=printf '%s\n' \"it's \\\"quoted\\\"\" > /w/out/q.out" ""
check param-quotes "single and double quotes reach zsh as typed" -- [ "$(cat /w/out/q.out 2>/dev/null)" = "it's \"quoted\"" ]
reset_state; runj hooktest-ok "" "" "" "" "" "PRE_REMOVE=printf %s a=b=c > /w/out/eq.out" ""
check param-equals "= inside the command" -- [ "$(cat /w/out/eq.out 2>/dev/null)" = "a=b=c" ]
check param-equals "not read as an option" -- hasnt "setting variable from argument PRE_REMOVE"
reset_state; runj hooktest-ok "" "" "" "" "" "" "POST_REMOVE=printf %s done > /w/out/p11only.out"
check param-11-only "parameter 11 alone, 5 to 10 empty" -- [ "$(cat /w/out/p11only.out 2>/dev/null)" = "done" ]
check param-11-only "label pre_remove kept" -- [ -f /w/out/pre.ok ]
reset_state; runj hooktest-ok "" "" "" "" "" "DEBUG=1 PRE_REMOVE_REQUIRED=1" ""
check param-options "two options in parameter 10 keep their meaning (DEBUG dry run)" -- has "DEBUG: dry run for HookTest finished"
check param-options "not taken as a hook command" -- hasnt "replaces the label's pre_remove"
check param-options "the label's pre_remove is kept" -- has "[DEBUG] would run pre_remove as root (timeout 120s): touch /w/out/pre.ok"
reset_state; runj hooktest-ok "" "" "" "" "" "touch /w/out/raw.ok" ""
check param-raw "a raw command without PRE_REMOVE= is not run" -- [ ! -f /w/out/raw.ok ]
check param-raw "the label's pre_remove ran" -- [ -f /w/out/pre.ok ]

# 14. precedence: option, then label; one parameter does not touch the other hook
reset_state; runj hooktest-ok "" "" "" "" "" "PRE_REMOVE=touch /w/out/p10.ok" ""
check precedence "the option beats the label" -- sh -c '[ -f /w/out/p10.ok ] && [ ! -f /w/out/pre.ok ]'
check precedence "label post_remove kept" -- [ -f /w/out/post.ok ]

# 15. option values as typed, without eval
reset_state; run hooktest-ok 'PRE_REMOVE="printf %s x=y > /w/out/opt-eq.out"'
check option-equals "= inside an option value" -- [ "$(cat /w/out/opt-eq.out 2>/dev/null)" = "x=y" ]
reset_state; run hooktest-ok "PRE_REMOVE=printf '%s' \"a  b\" > /w/out/opt-q.out"
check option-quotes "unwrapped value with quotes inside kept as typed" -- [ "$(cat /w/out/opt-q.out 2>/dev/null)" = "a  b" ]
reset_state; run hooktest-ok LOGGING=DEBUG "PRE_REMOVE=\"printf '%s' \\\"x\\\" > /w/out/opt-q2.out\""
check option-quotes "outer quotes with the same quote inside: left alone" -- has "PRE_REMOVE: \"printf '%s' \\\"x\\\" > /w/out/opt-q2.out\""
check option-quotes "value not logged at INFO" -- hasnt "INFO : hooktest-ok : PRE_REMOVE: "
reset_state; runcli hooktest-ok 'PRE_REMOVE=touch /w/out/cli.ok'
check option-cli "option from a shell (no Jamf slots)" -- [ -f /w/out/cli.ok ]

# 16. empty slots no longer end the list
reset_state; runj hooktest-prefail "" "" "" "" PRE_REMOVE_REQUIRED=1 "" ""
check skip-empty "option in parameter 9 after empty 5 to 8 is read (exit 12)" -- [ "$RC" -eq 12 ]
reset_state; runj hooktest-prefail "" "" "" "" "" PRE_REMOVE_REQUIRED=1 ""
check legacy-slot "a lone KEY=value in parameter 10 is an option (exit 12)" -- [ "$RC" -eq 12 ]

# 17. the safety gate for root hooks
reset_state; fake_bundle /Applications/Gate.app TEAM123456
run hooktest-gate
check gate-ok "signed, root-owned 755 bundle: ran as root" -- [ "$(cat /w/out/u/tool.ran 2>/dev/null)" = "root --deactivate" ]
reset_state; fake_bundle /Applications/Gate.app OTHER99999
run hooktest-gate
check gate-team "wrong Team ID: refused" -- has "pre_remove: refused, /Applications/Gate.app is signed by Team ID OTHER99999, expected TEAM123456"
check gate-team "not run" -- [ ! -f /w/out/u/tool.ran ]
check gate-team "removal went on (exit 0)" -- [ "$RC" -eq 0 ]
check gate-team "app removed" -- gone /Applications/Gate.app
reset_state; fake_bundle /Applications/Gate.app OTHER99999
run hooktest-gate PRE_REMOVE_REQUIRED=1
check gate-required "refused with REQUIRED: exit 12" -- [ "$RC" -eq 12 ]
check gate-required "reason logged" -- has "pre_remove was refused by the safety check and PRE_REMOVE_REQUIRED=1; nothing was removed"
check gate-required "app kept" -- [ -d /Applications/Gate.app ]
reset_state; fake_bundle /Applications/Gate.app TEAM123456; touch /Applications/Gate.app/.badsig
run hooktest-gate
check gate-sig "signature does not verify: refused" -- has "the signature of /Applications/Gate.app does not verify"
check gate-sig "not run" -- [ ! -f /w/out/u/tool.ran ]
reset_state; fake_bundle /Applications/Gate.app TEAM123456; chmod 777 /Applications/Gate.app/Contents/MacOS/tool
run hooktest-gate
check gate-writable "world-writable binary: refused" -- has "/Applications/Gate.app/Contents/MacOS/tool can be changed by its group or by anyone (mode 777)"
check gate-writable "not run" -- [ ! -f /w/out/u/tool.ran ]
reset_state; fake_bundle /Applications/Gate.app TEAM123456; chgrp 501 /Applications/Gate.app; chmod 775 /Applications/Gate.app
run hooktest-gate
check gate-writable "bundle writable by a standard user's group: refused" -- has "/Applications/Gate.app can be changed by its group or by anyone (mode 775)"
reset_state; fake_bundle /Applications/Gate.app TEAM123456; chmod 775 /Applications/Gate.app
run hooktest-gate
check gate-writable "group write for wheel (gid 0), as /Applications has for admin: ran" -- [ -f /w/out/u/tool.ran ]
reset_state; fake_bundle /Applications/Gate.app TEAM123456; chown -R testuser /Applications/Gate.app
run hooktest-gate
check gate-owner "bundle owned by a standard user: refused" -- has "/Applications/Gate.app/Contents/MacOS/tool belongs to uid 501, which is neither root nor an administrator"
check gate-owner "not run" -- [ ! -f /w/out/u/tool.ran ]
reset_state; fake_bundle /Applications/Gate.app TEAM123456; chown -R adminuser /Applications/Gate.app
run hooktest-gate
check gate-admin "bundle owned by an administrator: ran" -- [ -f /w/out/u/tool.ran ]
reset_state; fake_bundle /Applications/Gate.app OTHER99999; chown -R testuser /Applications/Gate.app
run hooktest-gate-user
check gate-as-user "as the user: no Team ID or owner requirement, ran" -- [ "$(cat /w/out/u/tool.ran 2>/dev/null)" = "testuser --deactivate" ]
check gate-as-user "signer still logged" -- has "/Applications/Gate.app is signed by Team ID OTHER99999; not required, it runs as the user"
reset_state; fake_bundle /Applications/Gate.app TEAM123456
run hooktest-gate-noteam
check gate-noteam "no Team ID set: refused" -- has "no hook_team_id or HOOK_TEAM_ID is set, so code inside /Applications/Gate.app will not run as root"
reset_state; fake_bundle /Applications/Gate.app TEAM123456
run hooktest-gate-noteam HOOK_TEAM_ID=TEAM123456
check gate-option "HOOK_TEAM_ID option supplies the Team ID: ran" -- [ -f /w/out/u/tool.ran ]
reset_state; fake_bundle /Applications/Gate.app OTHER99999
run hooktest-gate-env
check gate-wrapped "bundle named after /usr/bin/env is checked too" -- has "is signed by Team ID OTHER99999, expected TEAM123456"
check gate-wrapped "not run" -- [ ! -f /w/out/u/tool.ran ]
reset_state; fake_bundle /Applications/Gate.app OTHER99999
runj hooktest-ok "" "" "" "" "" "PRE_REMOVE=/Applications/Gate.app/Contents/MacOS/tool --from-policy" ""
check gate-param "parameter 10 into an app bundle, no Team ID: refused" -- has "no hook_team_id or HOOK_TEAM_ID is set"
check gate-param "not run" -- [ ! -f /w/out/u/tool.ran ]
reset_state; fake_bundle /Applications/Gate.app TEAM123456
runj hooktest-ok HOOK_TEAM_ID=TEAM123456 "" "" "" "" "PRE_REMOVE=/Applications/Gate.app/Contents/MacOS/tool --from-policy" ""
check gate-param "with HOOK_TEAM_ID in parameter 5: ran" -- [ "$(cat /w/out/u/tool.ran 2>/dev/null)" = "root --from-policy" ]
reset_state; fake_tool /usr/local/bin/hooktool 755 root
run hooktest-localbin
check gate-local "root-owned tool outside system paths: ran" -- [ -f /w/out/u/hooktool.ran ]
reset_state; fake_tool /usr/local/bin/hooktool 777 root
run hooktest-localbin
check gate-local "world-writable tool outside system paths: refused" -- has "/usr/local/bin/hooktool can be changed by its group or by anyone (mode 777)"
reset_state; fake_tool /usr/local/bin/hooktool 755 testuser
run hooktest-localbin
check gate-local "tool owned by a standard user: refused" -- has "/usr/local/bin/hooktool belongs to uid 501"
reset_state; fake_tool /usr/local/bin/hooktool 777 root
run hooktest-dotdot
check gate-dotdot "/usr/bin/../.. does not count as a system path" -- has "/usr/local/bin/hooktool can be changed by its group or by anyone"
check gate-dotdot "not run" -- [ ! -f /w/out/u/hooktool.ran ]
reset_state; fake_bundle /Applications/Gate.app TEAM123456; chown testuser /Applications/Gate.app/Contents/MacOS
run hooktest-gate
check gate-folder "root-owned tool in a folder a standard user owns: refused" -- has "/Applications/Gate.app/Contents/MacOS belongs to uid 501"
check gate-folder "not run" -- [ ! -f /w/out/u/tool.ran ]
reset_state; fake_tool /usr/local/bin/hooktool 755 root; chmod 777 /usr/local/bin
run hooktest-localbin
check gate-folder "root-owned tool in a world-writable folder: refused" -- has "/usr/local/bin can be changed by its group or by anyone (mode 777)"
check gate-folder "not run" -- [ ! -f /w/out/u/hooktool.ran ]
chmod 755 /usr/local/bin
reset_state; fake_tool /usr/local/bin/hooktool 777 root
run hooktest-chain
check gate-chain "second command after ; is checked too" -- has "/usr/local/bin/hooktool can be changed by its group or by anyone (mode 777)"
check gate-chain "nothing in the chain ran" -- sh -c '[ ! -f /w/out/u/hooktool.ran ] && [ ! -f /w/out/chain.first ]'
reset_state
runj hooktest-ok "" "" "" "" "" 'PRE_REMOVE=$HOME/bin/tool --x' ""
check gate-variable "program named through a variable: refused" -- has "cannot tell which program '\$HOME/bin/tool' is before it runs"
reset_state; runj hooktest-ok "" "" "" "" "" 'PRE_REMOVE=nosuchtool --x' ""
check gate-missing "program that cannot be found: refused" -- has "cannot find the program 'nosuchtool'"
reset_state; runj hooktest-ok PRE_REMOVE_AS_USER=1 "" "" "" "" 'PRE_REMOVE=nosuchtool --x' ""
check gate-missing "as the user the gate does not refuse it" -- hasnt "refused,"
reset_state; fake_bundle /Applications/Gate.app OTHER99999
run hooktest-gate DEBUG=1 PRE_REMOVE_REQUIRED=1
check gate-debug-required "DEBUG with REQUIRED: a refusal predicts exit 12" -- [ "$RC" -eq 12 ]
check gate-debug-required "app kept" -- [ -d /Applications/Gate.app ]
check gate-debug-required "tool not run" -- [ ! -f /w/out/u/tool.ran ]
reset_state; run hooktest-syspath
check gate-system "system path: no check, ran" -- [ -f /w/out/sys.ok ]
reset_state; fake_bundle /Applications/Gate.app OTHER99999
run hooktest-gate DEBUG=1
check gate-debug "DEBUG reports the refusal" -- has "[DEBUG] would refuse pre_remove: /Applications/Gate.app is signed by Team ID OTHER99999"
check gate-debug "DEBUG exit 0" -- [ "$RC" -eq 0 ]

# 17b. code a standard user can change, reached other than as the first word: refused
gate_refuses() { # gate_refuses CASE COMMAND: /Users/testuser/evil must stop COMMAND
  reset_state; fake_tool /Users/testuser/evil 755 testuser
  run hooktest-ok "PRE_REMOVE=$2"
  check "$1" "refused: $2" -- has "pre_remove: refused, /Users/testuser/evil belongs to uid 501"
  check "$1" "not run" -- [ ! -f /w/out/u/hooktool.ran ]
}
gate_refuses gate-arg-sh '/bin/sh /Users/testuser/evil'
gate_refuses gate-arg-shc "/bin/sh -c '/Users/testuser/evil --x'"
gate_refuses gate-arg-bashec "/bin/bash -ec 'true; /Users/testuser/evil'"
gate_refuses gate-arg-env '/usr/bin/env /Users/testuser/evil'
gate_refuses gate-arg-envopts '/usr/bin/env -i FOO=1 /Users/testuser/evil'
gate_refuses gate-arg-nohup '/usr/bin/nohup /Users/testuser/evil'
gate_refuses gate-builtin-exec 'exec /Users/testuser/evil'
gate_refuses gate-builtin-command 'command /Users/testuser/evil'
gate_refuses gate-builtin-source '. /Users/testuser/evil'
gate_refuses gate-procsubst '/bin/cat <(/Users/testuser/evil)'
gate_refuses gate-cmdsubst '/bin/echo "$(/Users/testuser/evil)"'
gate_refuses gate-backtick '/bin/echo `/Users/testuser/evil`'
gate_refuses gate-pipe-to-sh '/bin/cat /Users/testuser/evil | /bin/sh'
gate_refuses gate-redirect-to-sh '/bin/sh < /Users/testuser/evil'
gate_refuses gate-env-value 'DYLD_INSERT_LIBRARIES=/Users/testuser/evil /bin/true'
reset_state; run hooktest-ok 'PRE_REMOVE=eval touch /w/out/eval.ok'
check gate-eval "eval: refused" -- has "pre_remove: refused, eval hides which program runs"
check gate-eval "not run" -- [ ! -f /w/out/eval.ok ]
reset_state; run hooktest-ok 'PRE_REMOVE=/bin/cat $HOME/evil | /bin/sh'
check gate-var-file "a file named through a variable: refused" -- has "cannot tell which file '\$HOME/evil' is before it runs"
reset_state; mkdir -p /opt/v/bin; fake_tool /opt/v/bin/hooktool 755 root; chown testuser /opt/v
run hooktest-ok 'PRE_REMOVE=/opt/v/bin/hooktool'
check gate-chain-root "a folder two levels up owned by a standard user: refused" -- has "/opt/v belongs to uid 501"
check gate-chain-root "not run" -- [ ! -f /w/out/u/hooktool.ran ]
rm -rf /opt/v

# 17d. wrapper options, interpreter code, missing and relative paths (security review)
gate_says() { # gate_says CASE COMMAND REASON: COMMAND is refused for REASON and /Users/testuser/evil never runs
  reset_state; fake_tool /Users/testuser/evil 755 testuser
  run hooktest-ok "PRE_REMOVE=$2"
  check "$1" "refused: $2" -- has "pre_remove: refused, $3"
  check "$1" "not run" -- [ ! -f /w/out/u/hooktool.ran ]
}
gate_says gate-opt-envS "/usr/bin/env -S '/Users/testuser/evil'" "cannot tell what the option '-S' of env takes"
gate_says gate-opt-rcfile '/bin/bash --rcfile /Users/testuser/evil -i' "cannot tell what the option '--rcfile' of bash takes"
gate_refuses gate-opt-attached '/usr/bin/nice -n5 /Users/testuser/evil'
gate_refuses gate-opt-sudo '/usr/bin/sudo -u root /Users/testuser/evil'
gate_says gate-code-awk "awk 'BEGIN{system(\"/Users/testuser/evil\")}'" "cannot check the code in 'BEGIN{system(\"/Users/testuser/evil\")}'"
gate_refuses gate-code-spaces "/bin/echo 'system /Users/testuser/evil'"
gate_refuses gate-herestring '/bin/sh <<< /Users/testuser/evil'
gate_says gate-heredoc "/bin/sh <<EOF
/Users/testuser/evil
EOF" "here-documents are not checked"
gate_says gate-missing-path 'touch /Users/testuser/new.file' "/Users/testuser belongs to uid 501"
check gate-missing-path "file not created" -- [ ! -e /Users/testuser/new.file ]
gate_says gate-tilde '/bin/sh ~testuser/evil' "cannot tell which program '~testuser/evil' is before it runs"
gate_says gate-tilde-arg '/bin/cat ~testuser/evil' "cannot tell which file '~testuser/evil' is before it runs"
gate_refuses gate-relative '/bin/sh Users/testuser/evil'
gate_says gate-cd 'cd /Users/testuser && /bin/sh ./evil' "cd changes what relative paths name"
reset_state; run hooktest-ok "PRE_REMOVE=/bin/sh -ec 'touch /w/out/shec.ok'"
check gate-opt-ok "sh -ec with a command string: ran" -- [ -f /w/out/shec.ok ]
reset_state; run hooktest-ok 'PRE_REMOVE=/usr/bin/env -i PATH=/usr/bin:/bin touch /w/out/envi.ok'
check gate-opt-ok "env -i NAME=value program: ran" -- [ -f /w/out/envi.ok ]
reset_state; run hooktest-ok "PRE_REMOVE=echo a b | awk '{print \$2}' > /w/out/awk.out"
check gate-code-ok "awk code without a path: ran" -- [ "$(cat /w/out/awk.out 2>/dev/null)" = b ]
reset_state; run hooktest-ok 'PRE_REMOVE=/bin/pwd > /w/out/pwd.out'
check gate-cwd "hooks run from /" -- [ "$(cat /w/out/pwd.out 2>/dev/null)" = / ]

# 17e. links: the called name and the target both count as the program, and the link itself is
# checked as well as what it points to
reset_state; ln -sf /bin/bash /usr/local/bin/hooksh
run hooktest-ok "PRE_REMOVE=/usr/local/bin/hooksh -c 'touch /w/out/linkok.ok'"
check gate-link-ok "root-owned link to bash: ran" -- [ -f /w/out/linkok.ok ]
reset_state; ln -sf /bin/bash /usr/local/bin/hooksh
run hooktest-ok "PRE_REMOVE=/usr/local/bin/hooksh -c 'eval touch /w/out/linkeval.ok'"
check gate-link-target "link with another name to bash is a shell: its -c string is checked" -- has "pre_remove: refused, eval hides which program runs"
check gate-link-target "not run" -- [ ! -f /w/out/linkeval.ok ]
rm -f /usr/local/bin/hooksh
reset_state; ln -sf /bin/touch /Users/testuser/t; chown -h testuser /Users/testuser/t
run hooktest-ok 'PRE_REMOVE=/Users/testuser/t /w/out/userlink.ok'
check gate-link-owner "a standard user's link to a system program: refused" -- has "pre_remove: refused, /Users/testuser/t belongs to uid 501"
check gate-link-owner "not run" -- [ ! -f /w/out/userlink.ok ]
rm -f /Users/testuser/t
reset_state; fake_tool /Users/testuser/evil 755 testuser; ln -sf /bin/sh /usr/local/bin/hookfoo
run hooktest-ok 'PRE_REMOVE=/usr/local/bin/hookfoo /Users/testuser/evil'
check gate-link-oddname "link with an odd name to /bin/sh, user-writable script: refused" -- has "pre_remove: refused, /Users/testuser/evil belongs to uid 501"
check gate-link-oddname "not run" -- [ ! -f /w/out/u/hooktool.ran ]
rm -f /usr/local/bin/hookfoo
reset_state; ln -sf /bin/echo /Users/testuser/e; chown -h testuser /Users/testuser/e
run hooktest-ok 'PRE_REMOVE=/Users/testuser/e hi > /w/out/echo.out'
check gate-link-echo "a standard user's link to /bin/echo: refused" -- has "pre_remove: refused, /Users/testuser/e belongs to uid 501"
check gate-link-echo "not run" -- [ ! -f /w/out/echo.out ]
reset_state; ln -sf /Users/testuser/e /usr/local/bin/hookhop
run hooktest-ok 'PRE_REMOVE=/usr/local/bin/hookhop hi > /w/out/echo.out'
check gate-link-hop "root link through a standard user's link: refused" -- has "pre_remove: refused, /Users/testuser/e belongs to uid 501"
check gate-link-hop "not run" -- [ ! -f /w/out/echo.out ]
rm -f /usr/local/bin/hookhop /Users/testuser/e

# 17c. hooks the gate must still allow
reset_state; fake_tool /usr/local/bin/hooktool 755 root
run hooktest-ok 'PRE_REMOVE=/bin/sh /usr/local/bin/hooktool --via-sh'
check gate-arg-ok "root-owned script given to /bin/sh: ran" -- [ "$(cat /w/out/u/hooktool.ran 2>/dev/null)" = "root --via-sh" ]
reset_state; run hooktest-ok 'PRE_REMOVE=LANG=C touch /w/out/lang.ok'
check gate-envprefix "LANG=C before the program: ran" -- [ -f /w/out/lang.ok ]
reset_state; run hooktest-ok 'PRE_REMOVE=/bin/true >/dev/null 2>&1; touch /w/out/devnull.ok'
check gate-devnull "redirection to /dev/null: ran" -- [ -f /w/out/devnull.ok ]
reset_state; run hooktest-ok 'POST_REMOVE=/bin/rm -rf /Applications/HookTest.app/Contents; printf %s https://x.app/ > /w/out/url.out'
check gate-gone-app "post_remove naming the removed app and a .app URL: ran" -- [ "$(cat /w/out/url.out 2>/dev/null)" = "https://x.app/" ]
check gate-gone-app "not refused" -- hasnt "refused,"

# 18. a vendor uninstaller in pre_remove removes the app itself: the rest of the label still runs
reset_state; mkdir -p /w/leftover
run hooktest-vendorgone
check vendor-gone "exit 0" -- [ "$RC" -eq 0 ]
check vendor-gone "logged that pre_remove removed the app" -- has "pre_remove removed HookTest itself; removing what is left"
check vendor-gone "not reported as 'not found'" -- hasnt "not found in defined app paths"
check vendor-gone "leftover files removed" -- gone /w/leftover
check vendor-gone "post_remove ran" -- [ -f /w/out/post.ok ]
reset_state; rm -rf /Applications/HookTest.app; mkdir -p /w/leftover
run hooktest-vendorgone
check vendor-gone-absent "app absent from the start: still 'not found', exit 0" -- sh -c '[ "$0" -eq 0 ]' "$RC"
check vendor-gone-absent "not found logged" -- has "not found in defined app paths"
check vendor-gone-absent "nothing else touched" -- [ -d /w/leftover ]
rm -rf /w/leftover

echo "passed $PASS, failed $FAIL"
[ "$FAIL" -eq 0 ]
