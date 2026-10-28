microsoftoutlook)
    app_name="Outlook"
    bundle_id="com.microsoft.Outlook"
    app_paths=(
      "/Applications/Microsoft Outlook.app"
    )
    blockingProcesses=(
      "Microsoft Outlook"
    )
    # Relocated installs: the app can also sit at /Applications/Microsoft Outlook-N.localized/Microsoft Outlook.app
    for d in /Applications/*; do
      case "$d" in
        "/Applications/Microsoft Outlook-"*".localized") app_paths+=("$d") ;;
      esac
    done
    pkgs=(
      "com.microsoft.package.Microsoft_Outlook.app"
    )
    files=()
    user_files=(
      "%USER_HOME%/Library/Containers/com.microsoft.Outlook"
      "%USER_HOME%/Library/Preferences/com.microsoft.Outlook.plist"
      "%USER_HOME%/Library/Caches/com.microsoft.Outlook"
    )
    agents=()
    daemons=()
    profiles=()
;;
