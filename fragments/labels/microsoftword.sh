microsoftword)
    app_name="Word"
    bundle_id="com.microsoft.Word"
    app_paths=(
      "/Applications/Microsoft Word.app"
    )
    blockingProcesses=(
      "Microsoft Word"
    )
    # Relocated installs: the app can also sit at /Applications/Microsoft Word-N.localized/Microsoft Word.app
    for d in /Applications/*; do
      case "$d" in
        "/Applications/Microsoft Word-"*".localized") app_paths+=("$d") ;;
      esac
    done
    pkgs=(
      "com.microsoft.package.Microsoft_Word.app"
    )
    files=()
    user_files=(
      "%USER_HOME%/Library/Preferences/com.microsoft.Word.plist"
      "%USER_HOME%/Library/Caches/com.microsoft.Word"
    )
    agents=()
    daemons=()
    profiles=()
;;
