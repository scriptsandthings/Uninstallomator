audacity)
    # Every version of Audacity. Labels audacity3 and audacity4 remove one version.
    app_name="Audacity"
    bundle_id="org.audacityteam.audacity4"
    app_paths=(
      "/Applications/Audacity 4.app"
      "/Applications/Audacity.app"
    )
    pkgs=()
    files=()
    user_files=(
      "%USER_HOME%/Library/Application Support/audacity"
      "%USER_HOME%/Library/Preferences/org.audacityteam.audacity.plist"
      "%USER_HOME%/Library/Caches/Audacity"
      "%USER_HOME%/Library/Caches/org.audacityteam.audacity"
      "%USER_HOME%/Library/Saved Application State/org.audacityteam.audacity.savedState"
      "%USER_HOME%/Library/Preferences/org.audacityteam.audacity4.plist"
      "%USER_HOME%/Library/Saved Application State/org.audacityteam.audacity4.savedState"
    )
    agents=()
    daemons=()
    profiles=()
;;
