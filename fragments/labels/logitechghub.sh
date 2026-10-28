logitechghub)
    app_name="Logi G HUB"
    bundle_id="com.logi.ghub"
    app_paths=(
      "/Applications/lghub.app"
    )
    blockingProcesses=(
      "lghub"
      "lghub_agent"
      "lghub_system_tray"
      "lghub_ui"
    )
    pkgs=()
    files=(
      "/Library/Application Support/LGHUB"
      "/Library/Application Support/Logi/LGHUB"
    )
    user_files=(
      "%USER_HOME%/Library/Application Support/lghub"
      "%USER_HOME%/Library/Preferences/com.logi.ghub.plist"
      "%USER_HOME%/Library/Caches/com.logi.ghub"
      "%USER_HOME%/Library/Logs/lghub"
      "%USER_HOME%/Library/HTTPStorages/com.logi.ghub"
      "%USER_HOME%/Library/Saved Application State/com.logi.ghub.savedState"
      "%USER_HOME%/Library/Application Support/LGHUB"
      "%USER_HOME%/Library/Application Support/G HUB"
    )
    agents=(
      "/Library/LaunchAgents/com.logi.ghub.plist"
      "/Library/LaunchAgents/com.logi.ghub.agent.plist"
      "/Library/LaunchAgents/com.logi.ghub.updater.plist"
    )
    daemons=(
      "/Library/LaunchDaemons/com.logi.ghub.updater.plist"
    )
    profiles=()
;;
