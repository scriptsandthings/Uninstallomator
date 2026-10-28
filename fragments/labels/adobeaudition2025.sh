adobeaudition2025)
    # Adobe Audition 2025 only. Label adobeaudition removes every year.
    app_name="Audition 2025"
    bundle_id="com.adobe.Audition"
    app_paths=(
      "/Applications/Adobe Audition 2025"
    )
    pkgs=()
    files=(
      "/Library/Application Support/Adobe/Audition/25.0"
    )
    user_files=(
      "%USER_HOME%/Library/Preferences/Adobe/Audition/25.0"
    )
    # Every year shares the files below. Leave them while another year is still installed.
    other_years=( "/Applications/Adobe Audition "20[0-9][0-9](N/) )
    other_years=( ${other_years:#"/Applications/Adobe Audition 2025"} )
    if (( ${#other_years} == 0 )); then
      user_files+=(
        "%USER_HOME%/Library/Preferences/com.adobe.Audition.plist"
        "%USER_HOME%/Library/Caches/com.adobe.Audition"
        "%USER_HOME%/Library/Saved Application State/com.adobe.Audition.savedState"
      )
    fi
    agents=()
    daemons=()
    profiles=()
;;
