adobeaftereffects2025)
    # Adobe After Effects 2025 only. Label adobeaftereffects removes every year.
    app_name="After Effects 2025"
    bundle_id="com.adobe.AfterEffects.application"
    app_paths=(
      "/Applications/Adobe After Effects 2025"
    )
    pkgs=()
    files=(
      "/Library/Application Support/Adobe/After Effects/25.0"
    )
    user_files=(
      "%USER_HOME%/Library/Preferences/Adobe/After Effects/25.0"
    )
    # Every year shares the files below. Leave them while another year is still installed.
    other_years=( "/Applications/Adobe After Effects "20[0-9][0-9](N/) )
    other_years=( ${other_years:#"/Applications/Adobe After Effects 2025"} )
    if (( ${#other_years} == 0 )); then
      files+=(
        "/Library/Application Support/Adobe/Startup Scripts CC/Adobe After Effects"
      )
      user_files+=(
        "%USER_HOME%/Library/Preferences/com.adobe.AfterEffects.application.plist"
        "%USER_HOME%/Library/Caches/com.adobe.AfterEffects.application"
        "%USER_HOME%/Library/Logs/Adobe/After Effects"
        "%USER_HOME%/Library/Saved Application State/com.adobe.AfterEffects.application.savedState"
      )
    fi
    agents=()
    daemons=()
    profiles=()
;;
