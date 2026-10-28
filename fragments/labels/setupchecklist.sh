setupchecklist)
    app_name="Setup Checklist"
    bundle_id="com.jamf.setupchecklist"
    app_paths=(
      "/Applications/Setup Checklist.app"
    )
    pkgs=(
      "com.jamf.setupchecklist"
    )
    files=(
      "/usr/local/bin/setupchecklist"
      "/Users/Shared/.com.jamf.setupchecklist"
    )
    user_files=(
      "%USER_HOME%/Library/Preferences/com.jamf.setupchecklist.plist"
      "%USER_HOME%/Library/Preferences/com.jamf.setup.welcome.plist"
      "%USER_HOME%/Library/Caches/com.jamf.setupchecklist"
      "%USER_HOME%/Library/Saved Application State/com.jamf.setupchecklist.savedState"
    )
    agents=(
      "/Library/LaunchAgents/com.jamf.setupchecklist.plist"
    )
    daemons=()
    profiles=()
;;
