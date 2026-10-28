microsoftteamsrollingout)
    app_name="Microsoft Teams"
    bundle_id="com.microsoft.teams2"
    app_paths=(
      "/Applications/Microsoft Teams.app"
    )
    blockingProcesses=(
      "MSTeams"
      "Microsoft Teams"
      "Microsoft Teams WebView"
      "Microsoft Teams Launcher"
    )
    # The package also installs Microsoft AutoUpdate (com.microsoft.package.Microsoft_AutoUpdate.app).
    # Office shares it, so it is left in place.
    pkgs=(
      "com.microsoft.teams2"
      "com.microsoft.MSTeamsAudioDevice"
    )
    files=(
      "/Library/Audio/Plug-Ins/HAL/MSTeamsAudioDevice.driver"
      "/Library/Logs/Microsoft/MSTeams"
    )
    user_files=(
      "%USER_HOME%/Library/Containers/com.microsoft.teams2"
      "%USER_HOME%/Library/Containers/com.microsoft.teams2.launcher"
      "%USER_HOME%/Library/Containers/com.microsoft.teams2.notificationcenter"
      "%USER_HOME%/Library/Group Containers/UBF8T346G9.com.microsoft.teams"
      "%USER_HOME%/Library/Application Scripts/com.microsoft.teams2"
      "%USER_HOME%/Library/Application Scripts/com.microsoft.teams2.launcher"
      "%USER_HOME%/Library/Application Scripts/com.microsoft.teams2.notificationcenter"
    )
    agents=()
    daemons=()
    profiles=()
;;
