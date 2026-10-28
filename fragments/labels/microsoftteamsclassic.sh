microsoftteamsclassic)
    app_name="Microsoft Teams classic"
    bundle_id="com.microsoft.teams"
    app_paths=(
      "/Applications/Microsoft Teams classic.app"
    )
    pkgs=(
      "com.microsoft.teams"
    )
    files=(
      "/Library/Application Support/Microsoft/TeamsUpdaterDaemon"
      "/Library/Logs/Microsoft/Teams"
    )
    user_files=(
      "%USER_HOME%/Library/Application Support/Microsoft/Teams"
      "%USER_HOME%/Library/Preferences/com.microsoft.teams.plist"
      "%USER_HOME%/Library/Caches/com.microsoft.teams"
      "%USER_HOME%/Library/HTTPStorages/com.microsoft.teams"
      "%USER_HOME%/Library/Saved Application State/com.microsoft.teams.savedState"
      "%USER_HOME%/Library/Logs/Microsoft Teams"
      "%USER_HOME%/Library/Cookies/com.microsoft.teams.binarycookies"
      "%USER_HOME%/Library/Caches/com.microsoft.teams.ShipIt"
    )
    agents=()
    daemons=(
      "/Library/LaunchDaemons/com.microsoft.teams.TeamsUpdaterDaemon.plist"
    )
    profiles=()
;;
