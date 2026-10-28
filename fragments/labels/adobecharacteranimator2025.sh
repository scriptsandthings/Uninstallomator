adobecharacteranimator2025)
    # Adobe Character Animator 2025 only. Label adobecharacteranimator removes every year.
    app_name="Character Animator 2025"
    bundle_id="com.adobe.Character-Animator.application"
    app_paths=(
      "/Applications/Adobe Character Animator 2025"
    )
    pkgs=()
    files=(
      "/Library/Application Support/Adobe/Character Animator/25.0"
      "/Library/Application Support/Adobe/Uninstall/CHAR_25_0_32.app"
    )
    user_files=(
      "%USER_HOME%/Library/Application Support/Adobe/Character Animator/25.0"
      "%USER_HOME%/Library/Preferences/Adobe/Character Animator/25.0"
    )
    # Every year shares the files below. Leave them while another year is still installed.
    other_years=( "/Applications/Adobe Character Animator "20[0-9][0-9](N/) )
    other_years=( ${other_years:#"/Applications/Adobe Character Animator 2025"} )
    if (( ${#other_years} == 0 )); then
      user_files+=(
        "%USER_HOME%/Library/Preferences/com.adobe.Character-Animator.application.plist"
        "%USER_HOME%/Library/Caches/com.adobe.Character-Animator.application"
        "%USER_HOME%/Library/Saved Application State/com.adobe.Character-Animator.application.savedState"
      )
    fi
    agents=()
    daemons=()
    profiles=()
;;
