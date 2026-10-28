cleanmymacx)
    # CleanMyMac X 4.x (com.macpaw.CleanMyMac4). CleanMyMac 5 is the label cleanmymac.
    app_name="CleanMyMac X"
    bundle_id="com.macpaw.CleanMyMac4"
    app_paths=(
      "/Applications/CleanMyMac X.app"
    )
    blockingProcesses=(
      "CleanMyMac X Menu"
      "CleanMyMac X HealthMonitor"
    )
    pkgs=()
    files=(
      "/Library/PrivilegedHelperTools/com.macpaw.CleanMyMac4.Agent"
    )
    user_files=(
      "%USER_HOME%/Library/Application Support/CleanMyMac X"
      "%USER_HOME%/Library/Application Support/com.macpaw.CleanMyMac4"
      "%USER_HOME%/Library/Preferences/com.macpaw.CleanMyMac4.plist"
      "%USER_HOME%/Library/Preferences/com.macpaw.CleanMyMac4.Menu.plist"
      "%USER_HOME%/Library/Preferences/com.macpaw.CleanMyMac4.HealthMonitor.plist"
      "%USER_HOME%/Library/Caches/com.macpaw.CleanMyMac4"
      "%USER_HOME%/Library/Caches/com.macpaw.CleanMyMac4.Menu"
      "%USER_HOME%/Library/Caches/com.macpaw.CleanMyMac4.HealthMonitor"
      "%USER_HOME%/Library/HTTPStorages/com.macpaw.CleanMyMac4"
      "%USER_HOME%/Library/Saved Application State/com.macpaw.CleanMyMac4.savedState"
      "%USER_HOME%/Library/Logs/CleanMyMac X"
      "%USER_HOME%/Library/Group Containers/S8EX82NJP6.com.macpaw.CleanMyMac4"
    )
    agents=()
    daemons=(
      "/Library/LaunchDaemons/com.macpaw.CleanMyMac4.Agent.plist"
    )
    profiles=()
;;
