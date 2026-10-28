camostudio)
    app_name="Camo Studio"
    bundle_id="com.reincubate.macos.cam"
    app_paths=(
      "/Applications/Camo Studio.app"
    )
    pkgs=()
    files=(
      "/Library/PrivilegedHelperTools/com.reincubate.macos.cam.PrivilegedHelper"
      "/Library/Audio/Plug-Ins/HAL/ReincubateCamoAudio.driver"
    )
    user_files=(
      "%USER_HOME%/Library/Application Support/Camo Studio"
      "%USER_HOME%/Library/Application Support/com.reincubate.macos.cam"
      "%USER_HOME%/Library/Preferences/com.reincubate.macos.cam.plist"
      "%USER_HOME%/Library/Caches/com.reincubate.macos.cam"
      "%USER_HOME%/Library/HTTPStorages/com.reincubate.macos.cam"
      "%USER_HOME%/Library/Saved Application State/com.reincubate.macos.cam.savedState"
      "%USER_HOME%/Library/Logs/Camo Studio"
      "%USER_HOME%/Library/Group Containers/Q248YREB53.com.reincubate.macos.cam"
    )
    agents=()
    daemons=(
      "/Library/LaunchDaemons/com.reincubate.macos.cam.PrivilegedHelper.plist"
    )
    profiles=()
;;
