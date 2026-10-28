spotify)
    app_name="Spotify"
    bundle_id="com.spotify.client"
    app_paths=(
      "/Applications/Spotify.app"
    )
    pkgs=(
      "com.jamf.appinstallers.Spotify"
    )
    files=()
    user_files=(
      "%USER_HOME%/Applications/Spotify.app"
      "%USER_HOME%/Library/Application Support/Spotify"
      "%USER_HOME%/Library/Preferences/com.spotify.client.plist"
      "%USER_HOME%/Library/Preferences/com.spotify.client.helper.plist"
      "%USER_HOME%/Library/Caches/com.spotify.client"
      "%USER_HOME%/Library/Caches/com.spotify.client.ShipIt"
      "%USER_HOME%/Library/Logs/Spotify"
      "%USER_HOME%/Library/Saved Application State/com.spotify.client.savedState"
    )
    agents=()
    daemons=()
    profiles=()
;;
