selfserviceplus)
    app_name="Self Service+"
    bundle_id="com.jamf.selfserviceplus"
    app_paths=(
      "/Applications/Self Service+.app"
    )
    pkgs=(
      "com.jamf.selfserviceplus"
    )
    files=(
      "/Library/Application Support/Self Service+"
      "/usr/local/bin/selfservice"
    )
    user_files=(
      "%USER_HOME%/Library/Application Support/Self Service+"
      "%USER_HOME%/Library/Preferences/com.jamf.selfserviceplus.plist"
      "%USER_HOME%/Library/Preferences/com.jamf.selfserviceplus.agent.plist"
      "%USER_HOME%/Library/Preferences/com.jamf.selfserviceplus.telemetry.parameters.plist"
      "%USER_HOME%/Library/Caches/com.jamf.selfserviceplus"
      "%USER_HOME%/Library/HTTPStorages/com.jamf.selfserviceplus"
      "%USER_HOME%/Library/Saved Application State/com.jamf.selfserviceplus.savedState"
    )
    agents=(
      "/Library/LaunchAgents/com.jamf.selfserviceplus.agent.plist"
    )
    daemons=()
    profiles=()
    # The pre_remove runs a tool inside the bundle as root, so the bundle must be signed by Jamf.
    hook_team_id="483DWKW443"
    pre_remove=(
      "[ ! -x '/Applications/Self Service+.app/Contents/MacOS/Self Service+ CLI.app/Contents/MacOS/Self Service+ CLI' ] || '/Applications/Self Service+.app/Contents/MacOS/Self Service+ CLI.app/Contents/MacOS/Self Service+ CLI' branding prep-for-upgrade"
    )
;;
