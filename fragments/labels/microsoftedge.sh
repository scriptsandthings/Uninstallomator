microsoftedge)
    app_name="Edge"
    bundle_id="com.microsoft.edgemac"
    app_paths=(
      "/Applications/Microsoft Edge.app"
    )
    blockingProcesses=(
      "Microsoft Edge"
    )
    pkgs=(
      "com.microsoft.edgemac"
    )
    files=(
      "/Library/Microsoft/Edge"
      "/Library/Microsoft/EdgeUpdater"
      "/Library/Application Support/Microsoft/EdgeUpdater"
    )
    user_files=(
      "%USER_HOME%/Library/Preferences/com.microsoft.edgemac.plist"
      "%USER_HOME%/Library/Caches/Microsoft Edge"
      "%USER_HOME%/Library/Caches/com.microsoft.edgemac"
      "%USER_HOME%/Library/Saved Application State/com.microsoft.edgemac.savedState"
    )
    agents=()
    daemons=(
      "/Library/LaunchDaemons/com.microsoft.EdgeUpdater.wake.system.plist"
    )
    profiles=()
;;
