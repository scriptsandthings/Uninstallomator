cinema4d2025)
    # Maxon Cinema 4D 2025 only. Label cinema4d removes every year.
    app_name="Cinema 4D 2025"
    bundle_id="net.maxon.cinema4d"
    app_paths=(
      "/Applications/Maxon Cinema 4D 2025"
    )
    pkgs=()
    files=()
    user_files=()
    # Every year shares the files below. Leave them while another year is still installed.
    other_years=( "/Applications/Maxon Cinema 4D "20[0-9][0-9](N/) )
    other_years=( ${other_years:#"/Applications/Maxon Cinema 4D 2025"} )
    if (( ${#other_years} == 0 )); then
      user_files+=(
        "%USER_HOME%/Library/Preferences/net.maxon.cinema4d.plist"
        "%USER_HOME%/Library/Saved Application State/net.maxon.cinema4d.savedState"
        "%USER_HOME%/Library/Caches/net.maxon.cinema4d"
      )
    fi
    agents=()
    daemons=()
    profiles=()
;;
