cleanmymac)
    app_name="CleanMyMac"
    bundle_id="com.macpaw.CleanMyMac5"
    app_paths=(
      "/Applications/CleanMyMac.app"
      "/Applications/CleanMyMac_5.app"
      "/Applications/Setapp/CleanMyMac.app"
      "%USER_HOME%/Applications/Setapp/CleanMyMac.app"
    )
    pkgs=()
    files=(
      "/Library/PrivilegedHelperTools/com.macpaw.CleanMyMac5.Agent"
      "/Library/PrivilegedHelperTools/com.macpaw.CleanMyMac-setapp.Agent"
    )
    user_files=(
      "%USER_HOME%/Applications/Setapp/CleanMyMac.app"
      "%USER_HOME%/Library/Application Support/CleanMyMac"
      "%USER_HOME%/Library/Preferences/com.macpaw.CleanMyMac5.plist"
      "%USER_HOME%/Library/Caches/com.macpaw.CleanMyMac5"
      "%USER_HOME%/Library/HTTPStorages/com.macpaw.CleanMyMac5"
      "%USER_HOME%/Library/Saved Application State/com.macpaw.CleanMyMac5.savedState"
      "%USER_HOME%/Library/Logs/CleanMyMac"
      "%USER_HOME%/Library/Application Support/CleanMyMac X"
      "%USER_HOME%/Library/Preferences/com.macpaw.CleanMyMac-setapp.plist"
      "%USER_HOME%/Library/Caches/com.macpaw.CleanMyMac-setapp"
      "%USER_HOME%/Library/Application Support/com.macpaw.CleanMyMac5.HealthMonitor"
      "%USER_HOME%/Library/Application Support/com.macpaw.CleanMyMac5.Menu"
    )
    agents=()
    daemons=(
      "/Library/LaunchDaemons/com.macpaw.CleanMyMac5.Agent.plist"
      "/Library/LaunchDaemons/com.macpaw.CleanMyMac-setapp.Agent.plist"
    )
    profiles=()
;;
