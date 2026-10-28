qgisltr)
    app_name="QGIS-LTR"
    bundle_id="org.qgis.qgis3"
    # The LTR disk image holds QGIS.app, and Installomator installs it under that name. Older LTR
    # installs are QGIS-LTR.app. The release channel (qgispr) installs QGIS-final-<version>.app.
    app_paths=(
      "/Applications/QGIS.app"
      "/Applications/QGIS-LTR.app"
    )
    pkgs=()
    files=()
    user_files=(
      "%USER_HOME%/Library/Preferences/org.qgis.qgis3.plist"
      "%USER_HOME%/Library/Caches/QGIS"
      "%USER_HOME%/Library/Caches/org.qgis.qgis3"
      "%USER_HOME%/Library/Saved Application State/org.qgis.qgis3.savedState"
    )
    # Both channels share these user files. Leave them while a release build is still installed.
    other_channel=( "/Applications/QGIS-final-"*.app(N/) )
    if (( ${#other_channel} > 0 )); then
      user_files=()
    fi
    agents=()
    daemons=()
    profiles=()
;;
