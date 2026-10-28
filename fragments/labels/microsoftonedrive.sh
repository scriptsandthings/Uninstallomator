microsoftonedrive)
    app_name="OneDrive"
    bundle_id="com.microsoft.OneDrive"
    app_paths=(
      "/Applications/OneDrive.app"
    )
    pkgs=(
      "com.microsoft.OneDrive"
    )
    files=()
    user_files=(
      "%USER_HOME%/Library/Application Support/OneDrive"
      "%USER_HOME%/Library/Application Support/OneDrive Sync Service"
      "%USER_HOME%/Library/Containers/com.microsoft.OneDrive-mac"
      "%USER_HOME%/Library/Containers/com.microsoft.OneDrive.FinderSync"
      "%USER_HOME%/Library/Containers/com.microsoft.OneDrive.FileProvider"
      "%USER_HOME%/Library/Group Containers/UBF8T346G9.OneDriveStandaloneSuite"
      "%USER_HOME%/Library/Group Containers/UBF8T346G9.OfficeOneDriveSyncIntegration"
      "%USER_HOME%/Library/Preferences/com.microsoft.OneDrive.plist"
      "%USER_HOME%/Library/Caches/com.microsoft.OneDrive"
      "%USER_HOME%/Library/Logs/OneDrive"
    )
    agents=(
      "/Library/LaunchAgents/com.microsoft.OneDriveStandaloneUpdater.plist"
    )
    daemons=(
      "/Library/LaunchDaemons/com.microsoft.OneDriveStandaloneUpdaterDaemon.plist"
      "/Library/LaunchDaemons/com.microsoft.OneDriveUpdaterDaemon.plist"
    )
    profiles=()
;;
