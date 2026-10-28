microsoftautoupdate)
    # Troubleshooting only. Removing Microsoft AutoUpdate stops Office updates on the Mac. Reinstalling
    # Office, or running Installomator (microsoftautoupdate), puts it back.
    app_name="Microsoft AutoUpdate"
    bundle_id="com.microsoft.autoupdate2"
    app_paths=(
      "/Library/Application Support/Microsoft/MAU2.0/Microsoft AutoUpdate.app"
    )
    blockingProcesses=(
      "Microsoft Update Assistant"
      "Microsoft AU Daemon"
    )
    pkgs=(
      "com.microsoft.package.Microsoft_AutoUpdate.app"
      "com.microsoft.package.Microsoft_AU_Bootstrapper.app"
    )
    files=(
      "/Library/Application Support/Microsoft/MAU2.0"
      "/Library/PrivilegedHelperTools/com.microsoft.autoupdate.helper"
      "/Library/Caches/com.microsoft.autoupdate.fba"
      "/Library/Caches/com.microsoft.autoupdate.helper"
      "/Library/Preferences/com.microsoft.autoupdate2.plist"
      "/Library/Logs/Microsoft/autoupdate.log"
    )
    user_files=(
      "%USER_HOME%/Library/Application Support/Microsoft AutoUpdate"
      "%USER_HOME%/Library/Preferences/com.microsoft.autoupdate2.plist"
      "%USER_HOME%/Library/Preferences/com.microsoft.autoupdate.fba.plist"
      "%USER_HOME%/Library/Caches/com.microsoft.autoupdate2"
      "%USER_HOME%/Library/Caches/com.microsoft.autoupdate.fba"
      "%USER_HOME%/Library/HTTPStorages/com.microsoft.autoupdate2"
      "%USER_HOME%/Library/HTTPStorages/com.microsoft.autoupdate.fba"
      "%USER_HOME%/Library/Saved Application State/com.microsoft.autoupdate2.savedState"
    )
    agents=(
      "/Library/LaunchAgents/com.microsoft.update.agent.plist"
    )
    daemons=(
      "/Library/LaunchDaemons/com.microsoft.autoupdate.helper.plist"
    )
    profiles=()
;;
