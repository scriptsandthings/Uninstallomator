logitechoptions)
    app_name="Logi Options"
    bundle_id="com.logitech.Logi-Options"
    app_paths=(
      "/Applications/Logi Options.app"
      "/Applications/Utilities/LogiMgr Uninstaller.app"
    )
    pkgs=(
      "com.logitech.Logi-Options"
      "com.logitech.manager.pkg"
      "com.logitech.manager.preferencepane"
      "com.logitech.manager.uninstaller"
    )
    files=(
      "/Library/Application Support/Logitech.localized/Logitech Options.localized"
      "/Library/Extensions/LogiMgrDriver.kext"
      "/Library/Application Support/Logitech.localized/Logitech Preference Manager.localized"
    )
    user_files=(
      "%USER_HOME%/Library/Application Support/Logitech/Logitech Options"
      "%USER_HOME%/Library/Preferences/com.logitech.Logi-Options.plist"
      "%USER_HOME%/Library/Caches/com.logitech.Logi-Options"
      "%USER_HOME%/Library/Logs/Logitech/Logitech Options"
      "%USER_HOME%/Library/Saved Application State/com.logitech.Logi-Options.savedState"
      "%USER_HOME%/Library/Preferences/com.logitech.manager.plist"
      "%USER_HOME%/Library/Caches/com.logitech.manager"
      "%USER_HOME%/Library/Application Support/LogiOptions"
    )
    agents=(
      "/Library/LaunchAgents/com.logitech.manager.daemon.plist"
    )
    daemons=()
    profiles=()
;;
