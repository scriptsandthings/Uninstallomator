adobeillustrator2025)
    # Adobe Illustrator 2025 only. Label adobeillustrator removes every year.
    app_name="Illustrator 2025"
    bundle_id="com.adobe.illustrator"
    app_paths=(
      "/Applications/Adobe Illustrator 2025"
    )
    pkgs=()
    files=(
      "/Library/Application Support/Adobe/Scripting Dictionaries CC/Illustrator 2025"
      "/Library/Application Support/Adobe/Startup Scripts CC/Illustrator 2025"
    )
    user_files=(
      "%USER_HOME%/Library/Preferences/Adobe Illustrator 29 Settings"
    )
    # Every year shares the files below. Leave them while another year is still installed.
    other_years=( "/Applications/Adobe Illustrator "20[0-9][0-9](N/) )
    other_years=( ${other_years:#"/Applications/Adobe Illustrator 2025"} )
    if (( ${#other_years} == 0 )); then
      user_files+=(
        "%USER_HOME%/Library/Preferences/com.adobe.illustrator.plist"
        "%USER_HOME%/Library/Caches/com.adobe.illustrator"
        "%USER_HOME%/Library/Saved Application State/com.adobe.illustrator.savedState"
      )
    fi
    agents=()
    daemons=()
    profiles=()
;;
