microsoftremotehelp)
    app_name="Microsoft Remote Help"
    bundle_id="com.microsoft.remotehelp"
    app_paths=(
      "/Applications/Microsoft Remote Help.app"
    )
    pkgs=(
      "com.microsoft.remotehelp"
      "com.microsoft.remotehelp.scripts"
    )
    files=()
    user_files=(
      "%USER_HOME%/Library/Preferences/com.microsoft.remotehelp.plist"
      "%USER_HOME%/Library/Caches/com.microsoft.remotehelp"
      "%USER_HOME%/Library/HTTPStorages/com.microsoft.remotehelp"
      "%USER_HOME%/Library/Saved Application State/com.microsoft.remotehelp.savedState"
    )
    agents=()
    daemons=()
    profiles=()
;;
