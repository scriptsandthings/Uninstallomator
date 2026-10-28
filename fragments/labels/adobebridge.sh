adobebridge)
    # Every year of Adobe Bridge. Labels adobebridge2023, adobebridge2025 and adobebridge2026 remove one year.
    app_name="Adobe Bridge"
    bundle_id="com.adobe.bridge"
    app_paths=(
      "/Applications/Adobe Bridge 2026"
      "/Applications/Adobe Bridge 2025"
      "/Applications/Adobe Bridge 2023"
    )
    pkgs=()
    files=(
      "/Library/Application Support/Adobe/Adobe Bridge 2026"
      "/Library/Application Support/Adobe/Adobe Bridge 2025"
      "/Library/Application Support/Adobe/Bridge 2026 Extensions"
      "/Library/Application Support/Adobe/Bridge 2025 Extensions"
      "/Library/Application Support/Adobe/Startup Scripts CC/Adobe Bridge 2026"
      "/Library/Application Support/Adobe/Startup Scripts CC/Adobe Bridge 2025"
    )
    user_files=(
      "%USER_HOME%/Library/Preferences/com.adobe.bridge.plist"
      "%USER_HOME%/Library/Preferences/Adobe Bridge 2026 Settings"
      "%USER_HOME%/Library/Caches/com.adobe.bridge"
      "%USER_HOME%/Library/Saved Application State/com.adobe.bridge.savedState"
      "%USER_HOME%/Library/Preferences/com.adobe.bridge13.plist"
      "%USER_HOME%/Library/Caches/com.adobe.bridge13"
      "%USER_HOME%/Library/HTTPStorages/com.adobe.bridge13"
      "%USER_HOME%/Library/Saved Application State/com.adobe.bridge13.savedState"
      "%USER_HOME%/Library/Logs/Adobe Bridge 2023"
      "%USER_HOME%/Library/Preferences/Adobe Bridge 13 Settings"
      "%USER_HOME%/Library/Caches/Adobe/Bridge 2023"
    )
    agents=()
    daemons=()
    profiles=()
;;
