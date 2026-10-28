microsoftonenote)
    app_name="OneNote"
    bundle_id="com.microsoft.onenote.mac"
    app_paths=(
      "/Applications/Microsoft OneNote.app"
    )
    blockingProcesses=(
      "Microsoft OneNote"
    )
    # Relocated installs: the app can also sit at /Applications/Microsoft OneNote-N.localized/Microsoft OneNote.app
    for d in /Applications/*; do
      case "$d" in
        "/Applications/Microsoft OneNote-"*".localized") app_paths+=("$d") ;;
      esac
    done
    pkgs=(
      "com.microsoft.package.Microsoft_OneNote.app"
    )
    files=()
    user_files=(
      "%USER_HOME%/Library/Containers/com.microsoft.onenote.mac"
      "%USER_HOME%/Library/Preferences/com.microsoft.onenote.mac.plist"
      "%USER_HOME%/Library/Caches/com.microsoft.onenote.mac"
    )
    agents=()
    daemons=()
    profiles=()
;;
