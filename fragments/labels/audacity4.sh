audacity4)
    # Audacity 4 only. Label audacity removes every version.
    app_name="Audacity 4"
    bundle_id="org.audacityteam.audacity4"
    app_paths=(
      "/Applications/Audacity 4.app"
    )
    pkgs=()
    files=()
    user_files=(
      "%USER_HOME%/Library/Preferences/org.audacityteam.audacity4.plist"
      "%USER_HOME%/Library/Caches/org.audacityteam.audacity4"
      "%USER_HOME%/Library/Saved Application State/org.audacityteam.audacity4.savedState"
    )
    # Both versions share the folders below. Leave them while the other version is still installed.
    if [[ ! -d "/Applications/Audacity.app" ]]; then
      user_files+=(
        "%USER_HOME%/Library/Application Support/audacity"
        "%USER_HOME%/Library/Caches/Audacity"
      )
    fi
    agents=()
    daemons=()
    profiles=()
;;
