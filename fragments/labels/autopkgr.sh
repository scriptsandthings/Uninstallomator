autopkgr)
    app_name="AutoPkgr"
    bundle_id="com.lindegroup.AutoPkgr"
    app_paths=(
      "/Applications/AutoPkgr.app"
    )
    pkgs=()
    files=(
      "/Library/PrivilegedHelperTools/com.lindegroup.AutoPkgr.helper"
    )
    user_files=(
      "%USER_HOME%/Library/LaunchAgents/com.lindegroup.AutoPkgr.plist"
      "%USER_HOME%/Library/Application Support/AutoPkgr"
      "%USER_HOME%/Library/Preferences/com.lindegroup.AutoPkgr.plist"
      "%USER_HOME%/Library/Caches/com.lindegroup.AutoPkgr"
      "%USER_HOME%/Library/HTTPStorages/com.lindegroup.AutoPkgr"
      "%USER_HOME%/Library/Saved Application State/com.lindegroup.AutoPkgr.savedState"
      "%USER_HOME%/Library/Logs/AutoPkgr"
    )
    agents=()
    daemons=(
      "/Library/LaunchDaemons/com.lindegroup.AutoPkgr.helper.plist"
    )
    profiles=()
;;
