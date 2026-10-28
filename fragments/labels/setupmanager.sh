setupmanager)
    app_name="Setup Manager"
    bundle_id="com.jamf.setupmanager"
    app_paths=(
      "/Applications/Utilities/Setup Manager.app"
    )
    pkgs=(
      "com.jamf.setupmanager"
    )
    files=(
      "/Library/Logs/Setup Manager.log"
      "/private/var/log/setupManagerFinished.log"
      "/private/var/db/SetupManagerUserData.txt"
      "/Users/Shared/SetupManagerUserData.txt"
    )
    user_files=(
      "%USER_HOME%/Library/Preferences/com.jamf.setupmanager.plist"
    )
    agents=(
      "/Library/LaunchAgents/com.jamf.setupmanager.loginwindow.plist"
    )
    daemons=(
      "/Library/LaunchDaemons/com.jamf.setupmanager.plist"
      "/Library/LaunchDaemons/com.jamf.setupmanager.finished.plist"
    )
    profiles=()
;;
