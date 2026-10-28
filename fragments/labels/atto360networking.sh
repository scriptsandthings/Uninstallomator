atto360networking)
    app_name="ATTO360 Networking"
    bundle_id="com.atto.atto360n"
    app_paths=(
      "/Applications/ATTO360 Networking.app"
      "/Applications/ATTO 360 Networking.app"
    )
    pkgs=(
      "com.atto.app.atto360n"
      "com.atto.svc.atto360n"
    )
    files=(
      "/usr/local/libexec/atto360n"
      "/usr/local/bin/atto360nd-uninstall.sh"
    )
    user_files=(
      "%USER_HOME%/Library/Application Support/ATTO360 Networking"
      "%USER_HOME%/Library/Preferences/com.atto.atto360n.plist"
      "%USER_HOME%/Library/Caches/com.atto.atto360n"
      "%USER_HOME%/Library/Logs/ATTO360 Networking"
    )
    agents=()
    daemons=(
      "/Library/LaunchDaemons/com.atto.atto360nd.plist"
    )
    profiles=()
;;
