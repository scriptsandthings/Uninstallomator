plexmediaserver)
    app_name="Plex Media Server"
    bundle_id="com.plexapp.plexmediaserver"
    app_paths=(
      "/Applications/Plex Media Server.app"
    )
    pkgs=()
    files=()
    user_files=(
      "%USER_HOME%/Library/Logs/Plex Media Server"
      "%USER_HOME%/Library/Preferences/com.plexapp.plexmediaserver.plist"
      "%USER_HOME%/Library/Caches/com.plexapp.plexmediaserver"
      "%USER_HOME%/Library/HTTPStorages/com.plexapp.plexmediaserver"
      "%USER_HOME%/Library/Saved Application State/com.plexapp.plexmediaserver.savedState"
      "%USER_HOME%/Library/Preferences/com.plex.PlexUpdater.plist"
      "%USER_HOME%/Library/Caches/com.plex.PlexUpdater"
      "%USER_HOME%/Library/HTTPStorages/com.plex.PlexUpdater"
      "%USER_HOME%/Library/Saved Application State/com.plex.PlexUpdater.savedState"
    )
    agents=()
    daemons=()
    profiles=()
;;
