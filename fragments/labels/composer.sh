composer)
    app_name="Composer"
    bundle_id="com.jamfsoftware.Composer"
    app_paths=(
      "/Applications/Composer.app"
      "/Applications/Jamf Pro/Composer.app"
    )
    pkgs=(
      "composer"
    )
    files=(
      "/Library/PrivilegedHelperTools/com.jamfsoftware.Composer.helper"
    )
    user_files=(
      "%USER_HOME%/Library/Application Support/Composer"
      "%USER_HOME%/Library/Preferences/com.jamfsoftware.Composer.plist"
      "%USER_HOME%/Library/Caches/com.jamfsoftware.Composer"
      "%USER_HOME%/Library/HTTPStorages/com.jamfsoftware.Composer"
      "%USER_HOME%/Library/Saved Application State/com.jamfsoftware.Composer.savedState"
      "%USER_HOME%/Library/Logs/Composer"
    )
    agents=()
    daemons=(
      "/Library/LaunchDaemons/com.jamfsoftware.Composer.helper.plist"
    )
    profiles=()
;;
