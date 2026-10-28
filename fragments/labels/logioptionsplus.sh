logioptionsplus)
    app_name="Logi Options+"
    bundle_id="com.logi.optionsplus"
    app_paths=(
      "/Applications/logioptionsplus.app"
      "/Applications/Utilities/Logi Options+ Driver Installer.bundle"
    )
    blockingProcesses=(
      "logioptionsplus"
      "LogiPluginService"
    )
    pkgs=(
      "logioptionsplusinstaller"
      "logioptionsplusinstaller-v1.22.5550-staging"
      "com.logitech.LogiRightSightForWebcams.pkg"
      "com.logi.installer.pluginservice.package"
      "com.logi.installer.pluginservice.media.package"
    )
    files=(
      "/Library/Application Support/Logi/LogiOptionsPlus"
      "/Library/Application Support/Logitech.localized/LogiOptionsPlus"
      "/Library/Logs/Logi/logioptionsplus"
      "/Users/Shared/LogiOptionsPlus"
      "/Users/Shared/logioptionsplus_installer.app"
      "/private/tmp/logioptionsplus_installer.app"
      "/Library/Application Support/Logitech.localized/LogiRightSightForWebcams"
      "/Applications/Utilities/LogiPluginService.app"
      "/Library/Application Support/Logi/LogiPluginService"
    )
    user_files=(
      "%USER_HOME%/Library/Application Support/Logi/LogiOptionsPlus"
      "%USER_HOME%/Library/Application Support/LogiOptionsPlus"
      "%USER_HOME%/Library/Logs/Logi/logioptionsplus"
      "%USER_HOME%/Library/Preferences/com.logi.optionsplus.plist"
      "%USER_HOME%/Library/Preferences/com.logi.cp-dev-mgr.plist"
      "%USER_HOME%/Library/Preferences/com.logi.optionsplus.driverhost.plist"
      "%USER_HOME%/Library/Saved Application State/com.logi.optionsplus.savedState"
    )
    agents=(
      "/Library/LaunchAgents/com.logi.optionsplus.plist"
      "/Library/LaunchAgents/com.logi.cp-dev-mgr.plist"
      "/Library/LaunchAgents/com.logitech.LogiRightSight.Agent.plist"
    )
    daemons=(
      "/Library/LaunchDaemons/com.logi.optionsplus.updater.plist"
    )
    profiles=()
;;
