microsoftexcel)
    app_name="Excel"
    bundle_id="com.microsoft.Excel"
    app_paths=(
      "/Applications/Microsoft Excel.app"
    )
    blockingProcesses=(
      "Microsoft Excel"
    )
    # Relocated installs: the app can also sit at /Applications/Microsoft Excel-N.localized/Microsoft Excel.app
    for d in /Applications/*; do
      case "$d" in
        "/Applications/Microsoft Excel-"*".localized") app_paths+=("$d") ;;
      esac
    done
    pkgs=(
      "com.microsoft.package.Microsoft_Excel.app"
    )
    files=()
    user_files=(
      "%USER_HOME%/Library/Preferences/com.microsoft.Excel.plist"
      "%USER_HOME%/Library/Caches/com.microsoft.Excel"
    )
    agents=()
    daemons=()
    profiles=()
;;
