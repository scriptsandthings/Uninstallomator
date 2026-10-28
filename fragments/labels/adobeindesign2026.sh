adobeindesign2026)
    # Adobe InDesign 2026 only. Label adobeindesign removes every year.
    app_name="InDesign 2026"
    bundle_id="com.adobe.InDesign"
    app_paths=(
      "/Applications/Adobe InDesign 2026"
    )
    pkgs=()
    files=(
      "/Library/Application Support/Adobe/Installers/AdobeInDesign21AppBase"
    )
    user_files=()
    # Every year shares the files below. Leave them while another year is still installed.
    other_years=( "/Applications/Adobe InDesign "20[0-9][0-9](N/) )
    other_years=( ${other_years:#"/Applications/Adobe InDesign 2026"} )
    if (( ${#other_years} == 0 )); then
      files+=(
        "/Library/Application Support/Adobe/InDesign"
        "/Library/Application Support/Adobe/Startup Scripts CC/Adobe InDesign"
      )
      user_files+=(
        "%USER_HOME%/Library/Preferences/Adobe InDesign"
        "%USER_HOME%/Library/Preferences/com.adobe.InDesign.plist"
        "%USER_HOME%/Library/Caches/Adobe InDesign"
        "%USER_HOME%/Library/Caches/com.adobe.InDesign"
        "%USER_HOME%/Library/Saved Application State/com.adobe.InDesign.savedState"
      )
    fi
    agents=()
    daemons=()
    profiles=()
;;
