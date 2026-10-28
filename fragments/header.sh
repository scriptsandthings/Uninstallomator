#!/bin/zsh --no-rcs
label="" # if no label is sent to the script, this will be used

# Uninstallomator
#
# Uninstalls applications
# 2025 Uninstallomator
#
# Inspired by the Installomator project: https://github.com/Installomator

export PATH=/usr/bin:/bin:/usr/sbin:/sbin

# NOTE: adjust these variables:

# set to 0 for production, 1 for debugging
# while debugging, affected files will be listed, but
# also no actual uninstallation will be performed
DEBUG=1

# notify behavior
NOTIFY=success
# options:
#   - success      notify the user on success
#   - silent       no notifications
#   - all          all notifications (great for Self Service installation)

# logo-icon used in dialog boxes if app is blocking
LOGO=appstore
# options:
#   - appstore      Icon is Apple App Store (default)
#   - jamf          JAMF Pro
#   - mosyleb       Mosyle Business
#   - mosylem       Mosyle Manager (Education)
#   - addigy        Addigy
#   - microsoft     Microsoft Endpoint Manager (Intune)
#   - ws1           Workspace ONE (AirWatch)
#   - filewave      FileWave
#   - kandji        Kandji
# path can also be set in the command call, and if file exists, it will be used.
# Like 'LOGO="/System/Applications/App\ Store.app/Contents/Resources/AppIcon.icns"'
# (spaces have to be escaped).

# User Scope
USERSCOPE=0
# options:
#  - 0             Runs uninstall as the current user (default).
#  - 1             Uninstalls for all users.

#
### Removal hooks (pre_remove / post_remove)
# Some apps need a command run while they are still installed, or right after they are gone.
# The common case is a licence: the vendor's tool has to release the seat (for example
# `SomeApp.app/Contents/MacOS/SomeApp --deactivate`) before the app is deleted, or the seat stays
# used. Without hooks that takes a second script, ordered before this one in the same policy.
#
# A label can carry its own hooks:
#   pre_remove=( "command" ... )     run in order before anything is quit or removed
#   post_remove=( "command" ... )    run in order after the files are removed
#   pre_remove_as_user=1             run pre_remove as the console user instead of root
#   post_remove_as_user=1            the same for post_remove
#   hook_team_id="ABCDE12345"        Team ID that must sign an app bundle a root hook runs from
# Each command is one string, run as written by /bin/zsh --no-rcs -c.
#
# Hook options, given as KEY=value in any Jamf parameter (5 to 11) or on the command line. They are
# stored exactly as typed and never eval'd, so a command with spaces, quotes or "=" survives:
#   PRE_REMOVE=/Applications/X.app/Contents/MacOS/X --deactivate
# A parameter is a hook command only when it starts with PRE_REMOVE= or POST_REMOVE=; any other
# KEY=value keeps its usual meaning in every slot.
PRE_REMOVE=""             # a command to run before removal
POST_REMOVE=""            # a command to run after removal
PRE_REMOVE_AS_USER=""     # 1 = pre_remove as the console user, 0 = as root, empty = as the label says
POST_REMOVE_AS_USER=""    # the same for post_remove
PRE_REMOVE_REQUIRED=""    # 1 = stop before removing anything if pre_remove fails or is refused, 0 = go on;
                          # empty = 1 for an app that holds a system extension, 0 otherwise
HOOK_TIMEOUT=120          # seconds a hook may run before it is stopped and counted as failed
HOOK_TEAM_ID=""           # replaces the label's hook_team_id
# Precedence, for each hook on its own: the option wins over the label. Giving a pre-remove command
# does not touch the label's post_remove, and the other way round.
#
# Exit codes: 0 removed, or not installed (and every DEBUG run that would have worked)
#   1 label error, unknown label, or an app bundle is still there afterwards
#   6 not run as root   11 a process it quit is still running   98 macOS older than 10.14
#   12 pre_remove failed, or was refused by the safety check, and PRE_REMOVE_REQUIRED=1 (or the
#      app holds a system extension and PRE_REMOVE_REQUIRED is not 0); nothing removed

#
### Logging
# Logging behavior
LOGGING="INFO"
# options:
#   - DEBUG     Everything is logged
#   - INFO      (default) normal logging level
#   - WARN      only warning
#   - ERROR     only errors
#   - REQ       ????

# Log Date format used when parsing logs for debugging, this is the default used by
# install.log, override this in the case statements if you need something custom per
# application (See adobeillustrator).  Using stadard GNU Date formatting.
LogDateFormat="%Y-%m-%d %H:%M:%S"

# Get the start time for parsing install.log if we fail.
starttime=$(date "+$LogDateFormat")

# Check if we have rosetta installed
if [[ $(/usr/bin/arch) == "arm64" ]]; then
    if ! arch -x86_64 /usr/bin/true >/dev/null 2>&1; then # pgrep oahd >/dev/null 2>&1
        rosetta2=no
    fi
fi