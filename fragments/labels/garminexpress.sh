garminexpress)
    app_name="Garmin Express"
    bundle_id="com.garmin.renu.client"
    app_paths=(
      "/Applications/Garmin Express.app"
    )
    pkgs=(
      "com.garmin.renu.client"
      "com.garmin.renu.service"
      "com.garmin.ApplicationUpdater"
      "net.oauth.OAuthConsumer"
    )
    files=()
    user_files=(
      "%USER_HOME%/Library/Application Support/Garmin Express"
      "%USER_HOME%/Library/Preferences/com.garmin.renu.client.plist"
      "%USER_HOME%/Library/Caches/com.garmin.renu.client"
      "%USER_HOME%/Library/Logs/Garmin Express"
      "%USER_HOME%/Library/HTTPStorages/com.garmin.renu.client"
      "%USER_HOME%/Library/Saved Application State/com.garmin.renu.client.savedState"
      "%USER_HOME%/Library/WebKit/com.garmin.renu.client"
      "%USER_HOME%/Library/Preferences/com.garmin.renu.service.plist"
      "%USER_HOME%/Library/Application Support/Garmin/Garmin Express"
      "%USER_HOME%/Library/Caches/com.garmin.renu.service"
      "%USER_HOME%/Library/Logs/Garmin Express Service"
    )
    agents=()
    daemons=()
    profiles=()
;;
