remotedesktop)
    app_name="Remote Desktop"
    bundle_id="com.apple.RemoteDesktop"
    app_paths=(
      "/Applications/Remote Desktop.app"
    )
    pkgs=()
    files=(
      "/Library/Application Support/Apple/Remote Desktop/Shared Settings"
      "/Library/Application Support/Apple/Remote Desktop/Task Server"
    )
    user_files=(
      "%USER_HOME%/Library/Application Support/Remote Desktop"
      "%USER_HOME%/Library/Preferences/com.apple.RemoteDesktop.plist"
      "%USER_HOME%/Library/Caches/com.apple.RemoteDesktop"
      "%USER_HOME%/Library/Logs/Remote Desktop"
    )
    agents=()
    daemons=()
    profiles=()
;;
