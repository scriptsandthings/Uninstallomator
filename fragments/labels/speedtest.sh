speedtest)
    app_name="Speedtest"
    bundle_id="com.ookla.speedtest-macos"
    app_paths=(
      "/Applications/Speedtest.app"
    )
    pkgs=()
    files=()
    user_files=(
      "%USER_HOME%/Library/Application Support/Speedtest"
      "%USER_HOME%/Library/Logs/Speedtest"
      "%USER_HOME%/Library/Preferences/com.ookla.speedtest-macos.plist"
      "%USER_HOME%/Library/Caches/com.ookla.speedtest-macos"
      "%USER_HOME%/Library/HTTPStorages/com.ookla.speedtest-macos"
      "%USER_HOME%/Library/Saved Application State/com.ookla.speedtest-macos.savedState"
      "%USER_HOME%/Library/Containers/com.ookla.speedtest-macos"
    )
    agents=()
    daemons=()
    profiles=()
;;
