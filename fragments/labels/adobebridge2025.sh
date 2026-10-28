adobebridge2025)
    # Adobe Bridge 2025 only. Label adobebridge removes every year.
    app_name="Adobe Bridge 2025"
    bundle_id="com.adobe.bridge"
    app_paths=(
      "/Applications/Adobe Bridge 2025"
    )
    pkgs=()
    files=(
      "/Library/Application Support/Adobe/Adobe Bridge 2025"
      "/Library/Application Support/Adobe/Bridge 2025 Extensions"
      "/Library/Application Support/Adobe/Startup Scripts CC/Adobe Bridge 2025"
    )
    user_files=(
    )
    # Every year shares the files below. Leave them while another year is still installed.
    other_years=( "/Applications/Adobe Bridge "20[0-9][0-9](N/) )
    other_years=( ${other_years:#"/Applications/Adobe Bridge 2025"} )
    if (( ${#other_years} == 0 )); then
      user_files+=(
        "%USER_HOME%/Library/Preferences/com.adobe.bridge.plist"
        "%USER_HOME%/Library/Caches/com.adobe.bridge"
        "%USER_HOME%/Library/Saved Application State/com.adobe.bridge.savedState"
      )
    fi
    agents=()
    daemons=()
    profiles=()
;;
