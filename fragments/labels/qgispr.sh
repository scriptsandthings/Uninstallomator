qgispr)
    app_name="QGIS"
    bundle_id="org.qgis.qgis3"
    # The release disk image names the app after its version (QGIS-final-4_2_3.app) and each
    # release installs next to the last, so this removes every one. QGIS.app is the LTR build now
    # (qgisltr).
    app_paths=(
      "/Applications/QGIS-final-"*.app(N/)
    )
    pkgs=()
    files=()
    user_files=(
      "%USER_HOME%/Library/Preferences/org.qgis.qgis3.plist"
      "%USER_HOME%/Library/Caches/QGIS"
      "%USER_HOME%/Library/Caches/org.qgis.qgis3"
      "%USER_HOME%/Library/Saved Application State/org.qgis.qgis3.savedState"
    )
    # Both channels share these user files. Leave them while the LTR build is still installed.
    if [[ -d "/Applications/QGIS.app" || -d "/Applications/QGIS-LTR.app" ]]; then
      user_files=()
    fi
    agents=()
    daemons=()
    profiles=()
;;
