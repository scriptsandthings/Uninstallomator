teamviewerhost)
    app_name="TeamViewerHost"
    bundle_id="com.teamviewer.TeamViewerHost"
    app_paths=(
      "/Applications/TeamViewerHost.app"
    )
    pkgs=(
      "com.teamviewer.teamviewerhost"
      "com.teamviewer.AuthorizationPlugin"
      "com.teamviewer.AuthorizationResources"
      "com.teamviewer.RemotePrintingPackage"
      "com.teamviewer.teamviewerhostEnforceUIVersion"
      "com.teamviewer.teamviewerhostSilentInstaller"
      "com.teamviewer.teamviewerSilentInstaller"
      "com.teamviewer.teamviewerPriviledgedHelper"
      "com.teamviewer.teamviewerUninstallerApp"
      "com.teamviewer.teamviewerUninstallerHelper"
    )
    files=(
      "/Library/Application Support/TeamViewer"
      "/Library/Security/SecurityAgentPlugins/TeamViewerAuthPlugin.bundle"
      "/Library/PrivilegedHelperTools/com.teamviewer.Helper"
      "/Library/PrivilegedHelperTools/com.teamviewer.UninstallerHelper"
      "/Library/PrivilegedHelperTools/com.teamviewer.ScriptExecutionHelper"
      "/Library/Audio/Plug-Ins/HAL/TVRemoteAudio.driver"
      "/Library/Printers/Icons/TeamViewer.icns"
      "/Library/Caches/com.teamviewer.TeamViewer.RemotePrinting"
      "/Library/Preferences/com.teamviewer.teamviewer.preferences.plist"
      "/etc/cups/ppd/TVPDF.ppd"
      "/usr/libexec/cups/filter/pdftoteamviewer"
    )
    user_files=(
      "%USER_HOME%/Library/Application Support/TeamViewer Host"
      "%USER_HOME%/Library/Preferences/com.teamviewer.teamviewer.preferences.plist"
      "%USER_HOME%/Library/Preferences/com.teamviewer.TeamViewerHost.plist"
      "%USER_HOME%/Library/Caches/com.teamviewer.TeamViewerHost"
      "%USER_HOME%/Library/Logs/TeamViewer"
    )
    agents=(
      "/Library/LaunchAgents/com.teamviewer.teamviewer.plist"
      "/Library/LaunchAgents/com.teamviewer.teamviewer_desktop.plist"
    )
    daemons=(
      "/Library/LaunchDaemons/com.teamviewer.teamviewer_service.plist"
      "/Library/LaunchDaemons/com.teamviewer.Helper.plist"
      "/Library/LaunchDaemons/com.teamviewer.ScriptExecutionHelper.plist"
      "/Library/LaunchDaemons/com.teamviewer.UninstallerHelper.plist"
      "/Library/LaunchDaemons/com.teamviewer.UninstallerWatcher.plist"
    )
    profiles=()
    # The full client and Host share the helpers, auth plugin, printing files, launchd items, receipts and the
    # preferences file. While TeamViewer.app is still installed those stay, or it stops working.
    if [[ -d "/Applications/TeamViewer.app" ]]; then
      files=()
      agents=()
      daemons=()
      pkgs=(
        "com.teamviewer.teamviewerhost"
      )
      user_files=(
        "%USER_HOME%/Library/Application Support/TeamViewer Host"
        "%USER_HOME%/Library/Preferences/com.teamviewer.TeamViewerHost.plist"
        "%USER_HOME%/Library/Caches/com.teamviewer.TeamViewerHost"
      )
    fi
;;
