adobeincopy2025)
    # Adobe InCopy 2025 only. Label adobeincopy removes every year.
    app_name="InCopy 2025"
    bundle_id="com.adobe.InCopy"
    app_paths=(
      "/Applications/Adobe InCopy 2025"
    )
    pkgs=()
    files=(
      "/Library/Application Support/Adobe/Installers/AdobeInCopy20AppBase"
    )
    user_files=()
    # Every year shares the files below. Leave them while another year is still installed.
    other_years=( "/Applications/Adobe InCopy "20[0-9][0-9](N/) )
    other_years=( ${other_years:#"/Applications/Adobe InCopy 2025"} )
    if (( ${#other_years} == 0 )); then
      files+=(
        "/Library/Application Support/Adobe/InCopy"
        "/Library/Application Support/Adobe/Startup Scripts CC/Adobe InCopy"
      )
      user_files+=(
        "%USER_HOME%/Library/Preferences/Adobe InCopy"
        "%USER_HOME%/Library/Preferences/com.adobe.InCopy.plist"
        "%USER_HOME%/Library/Caches/Adobe InCopy"
        "%USER_HOME%/Library/Caches/com.adobe.InCopy"
        "%USER_HOME%/Library/Saved Application State/com.adobe.InCopy.savedState"
      )
    fi
    agents=()
    daemons=()
    profiles=()
;;
