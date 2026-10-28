caffeinedomzilla)
    # The Dominic Rodemer Caffeine (bundle id net.domzilla.caffeine) installs /Applications/Caffeine.app like the
    # older IntelliScape Caffeine (label caffeine). This label acts only on its own bundle id.
    if [[ -d "/Applications/Caffeine.app" ]] && [[ "$(/usr/libexec/PlistBuddy -c "Print :CFBundleIdentifier" "/Applications/Caffeine.app/Contents/Info.plist" 2>/dev/null)" != "net.domzilla.caffeine" ]]; then
      cleanupAndExit 0 "Caffeine.app is not the net.domzilla.caffeine build; nothing removed. Use the caffeine label for it" WARN
    fi
    app_name="Caffeine"
    bundle_id="net.domzilla.caffeine"
    app_paths=(
      "/Applications/Caffeine.app"
    )
    pkgs=()
    files=()
    user_files=(
      "%USER_HOME%/Library/Preferences/net.domzilla.caffeine.plist"
      "%USER_HOME%/Library/Caches/net.domzilla.caffeine"
      "%USER_HOME%/Library/HTTPStorages/net.domzilla.caffeine"
      "%USER_HOME%/Library/Saved Application State/net.domzilla.caffeine.savedState"
    )
    agents=()
    daemons=()
    profiles=()
;;
