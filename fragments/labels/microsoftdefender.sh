microsoftdefender)
    app_name="Microsoft Defender"
    bundle_id="com.microsoft.wdav"
    app_paths=(
      "/Applications/Microsoft Defender.app"
      "/Applications/Microsoft Defender ATP.app"
      "/Applications/Microsoft Defender Shim.app"
    )
    pkgs=(
      "com.microsoft.wdav"
      "com.microsoft.dlp.agent"
      "com.microsoft.dlp.daemon"
      "com.microsoft.dlp.ux"
    )
    files=(
      "/Library/Application Support/Microsoft/Defender"
      "/Library/Application Support/Microsoft/DLP"
      "/Library/Logs/Microsoft/mdatp"
      "/Library/Extensions/wdavkext.kext"
      "/usr/local/bin/mdatp"
      "/usr/local/share/zsh/site-functions/_mdatp"
      "/var/root/Library/Group Containers/UBF8T346G9.com.microsoft.wdavdaemon"
      "/var/root/Library/Group Containers/UBF8T346G9.com.microsoft.dlp"
    )
    user_files=(
      "%USER_HOME%/Library/Preferences/com.microsoft.wdav.tray.plist"
      "%USER_HOME%/Library/Preferences/com.microsoft.wdav.plist"
      "%USER_HOME%/Library/Group Containers/UBF8T346G9.com.microsoft.wdavdaemon"
    )
    agents=(
      "/Library/LaunchAgents/com.microsoft.wdav.tray.plist"
      "/Library/LaunchAgents/com.microsoft.dlp.agent.plist"
      "/Library/LaunchAgents/com.microsoft.dlp.session_monitor.plist"
    )
    daemons=(
      "/Library/LaunchDaemons/com.microsoft.fresno.plist"
      "/Library/LaunchDaemons/com.microsoft.fresno.uninstall.plist"
      "/Library/LaunchDaemons/com.microsoft.dlp.daemon.plist"
      "/Library/LaunchDaemons/com.microsoft.dlp.install_monitor.plist"
      "/Library/LaunchDaemons/com.microsoft.wdav.dlpprocessordaemon.plist"
      "/Library/LaunchDaemons/com.microsoft.wdav.dlp_processor_install_monitor.plist"
      "/Library/LaunchDaemons/com.microsoft.wdav.tracedaemon.plist"
      "/Library/LaunchDaemons/com.microsoft.wdav.tracer_install_monitor.plist"
    )
    profiles=()
    pre_remove=(
      "'/Library/Application Support/Microsoft/Defender/uninstall/uninstall'"
    )
;;
