aescriptsmanager)
    app_name="aescripts + aeplugins"
    bundle_id="com.aescripts.updater.Updater"
    app_paths=(
      "/Applications/aescripts + aeplugins.app"
    )
    blockingProcesses=(
      "aescripts + aeplugins"
    )
    pkgs=()
    # Privileged helper the app installs on first run (Contents/Library/LaunchServices).
    files=(
      "/Library/PrivilegedHelperTools/com.aescripts.updater.helper"
    )
    user_files=(
      "%USER_HOME%/Library/Preferences/com.aescripts.updater.Updater.plist"
      "%USER_HOME%/Library/Caches/com.aescripts.updater.Updater"
      "%USER_HOME%/Library/HTTPStorages/com.aescripts.updater.Updater"
      "%USER_HOME%/Library/Saved Application State/com.aescripts.updater.Updater.savedState"
    )
    agents=()
    daemons=(
      "/Library/LaunchDaemons/com.aescripts.updater.helper.plist"
    )
    profiles=()
;;
