audacity3)
    # Audacity 3 only. Label audacity removes every version.
    app_name="Audacity 3"
    bundle_id="org.audacityteam.audacity"
    app_paths=(
      "/Applications/Audacity.app"
    )
    pkgs=()
    files=()
    user_files=(
      "%USER_HOME%/Library/Preferences/org.audacityteam.audacity.plist"
      "%USER_HOME%/Library/Caches/org.audacityteam.audacity"
      "%USER_HOME%/Library/Saved Application State/org.audacityteam.audacity.savedState"
    )
    # Both versions share the folders below. Leave them while the other version is still installed.
    if [[ ! -d "/Applications/Audacity 4.app" ]]; then
      user_files+=(
        "%USER_HOME%/Library/Application Support/audacity"
        "%USER_HOME%/Library/Caches/Audacity"
      )
    fi
    agents=()
    daemons=()
    profiles=()
;;
