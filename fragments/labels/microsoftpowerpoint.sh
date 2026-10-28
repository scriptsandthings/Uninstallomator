microsoftpowerpoint)
    app_name="PowerPoint"
    bundle_id="com.microsoft.Powerpoint"
    app_paths=(
      "/Applications/Microsoft PowerPoint.app"
    )
    blockingProcesses=(
      "Microsoft PowerPoint"
    )
    # Relocated installs: the app can also sit at /Applications/Microsoft PowerPoint-N.localized/Microsoft PowerPoint.app
    for d in /Applications/*; do
      case "$d" in
        "/Applications/Microsoft PowerPoint-"*".localized") app_paths+=("$d") ;;
      esac
    done
    pkgs=(
      "com.microsoft.package.Microsoft_PowerPoint.app"
    )
    files=()
    user_files=(
      "%USER_HOME%/Library/Preferences/com.microsoft.Powerpoint.plist"
      "%USER_HOME%/Library/Caches/com.microsoft.Powerpoint"
    )
    agents=()
    daemons=()
    profiles=()
;;
