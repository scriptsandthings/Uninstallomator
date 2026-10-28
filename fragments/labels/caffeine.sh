caffeine)
    # The older IntelliScape Caffeine and the Dominic Rodemer Caffeine (label caffeinedomzilla) both install
    # /Applications/Caffeine.app. This label acts only on the IntelliScape bundle id.
    if [[ -d "/Applications/Caffeine.app" ]] && [[ "$(/usr/libexec/PlistBuddy -c "Print :CFBundleIdentifier" "/Applications/Caffeine.app/Contents/Info.plist" 2>/dev/null)" != "com.intelliscapesolutions.caffeine" ]]; then
      cleanupAndExit 0 "Caffeine.app is not the IntelliScape build; nothing removed. Use the caffeinedomzilla label for it" WARN
    fi
    app_name="Caffeine"
    bundle_id="com.intelliscapesolutions.caffeine"
    app_paths=(
      "/Applications/Caffeine.app"
    )
    pkgs=()
    files=()
    user_files=(
      "%USER_HOME%/Library/Application Support/Caffeine"
      "%USER_HOME%/Library/Preferences/com.intelliscapesolutions.caffeine.plist"
      "%USER_HOME%/Library/Caches/com.intelliscapesolutions.caffeine"
      "%USER_HOME%/Library/HTTPStorages/com.intelliscapesolutions.caffeine"
      "%USER_HOME%/Library/Saved Application State/com.intelliscapesolutions.caffeine.savedState"
      "%USER_HOME%/Library/Logs/Caffeine"
    )
    agents=()
    daemons=()
    profiles=()
;;
