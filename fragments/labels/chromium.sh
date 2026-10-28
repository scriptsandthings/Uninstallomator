chromium)
    app_name="Chromium"
    bundle_id="org.chromium.Chromium"
    app_paths=(
      "/Applications/Chromium.app"
    )
    pkgs=()
    files=(
      "/Library/Application Support/Chromium"
      "/Library/Application Support/chromium"
      "/Library/Application Support/chromium/NativeMessagingHosts"
    )
    user_files=(
      "%USER_HOME%/Library/Preferences/org.chromium.Chromium.plist"
      "%USER_HOME%/Library/Caches/org.chromium.Chromium"
      "%USER_HOME%/Library/Logs/Chromium"
    )
    agents=()
    daemons=()
    profiles=()
;;
