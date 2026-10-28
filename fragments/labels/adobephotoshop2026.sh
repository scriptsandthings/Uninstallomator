adobephotoshop2026)
    # Adobe Photoshop 2026 only. Label adobephotoshop removes every year.
    app_name="Photoshop 2026"
    bundle_id="com.adobe.Photoshop"
    app_paths=(
      "/Applications/Adobe Photoshop 2026"
    )
    pkgs=()
    files=(
      "/Library/Application Support/Adobe/Adobe Photoshop 2026"
    )
    user_files=(
      "%USER_HOME%/Library/Preferences/Adobe Photoshop 2026 Settings"
      "%USER_HOME%/Library/Caches/Adobe Photoshop 2026"
      "%USER_HOME%/Library/Logs/Adobe Photoshop 2026"
    )
    # Every year shares the files below. Leave them while another year is still installed.
    other_years=( "/Applications/Adobe Photoshop "20[0-9][0-9](N/) )
    other_years=( ${other_years:#"/Applications/Adobe Photoshop 2026"} )
    if (( ${#other_years} == 0 )); then
      files+=(
        "/Library/Application Support/Adobe/Startup Scripts CC/Adobe Photoshop"
        "/Library/Application Support/Adobe/Scripting Dictionaries CC/photoshop"
      )
      user_files+=(
        "%USER_HOME%/Library/Preferences/com.adobe.Photoshop.plist"
        "%USER_HOME%/Library/Caches/com.adobe.Photoshop"
        "%USER_HOME%/Library/Saved Application State/com.adobe.Photoshop.savedState"
      )
    fi
    agents=()
    daemons=()
    profiles=()
;;
