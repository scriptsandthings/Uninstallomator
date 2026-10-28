attofastframe3)
    # Intended: the app label and the driver label both delete the app. The DriverKit extension lives inside the app bundle, so the app is the only thing to remove. Not a lookalike overlap.
    # The legacy kext and the DriverKit-only removal are the labels attofastframe3legacydriver and attofastframe3driver.
    app_name="ATTO FastFrame 3"
    bundle_id="com.atto.fastframe3app"
    app_paths=(
      "/Applications/ATTO FastFrame 3.app"
    )
    pkgs=(
      "com.atto.fastframe3d.atto360n"
      "attofastframe3v1.00.3"
      "attofastframe3v1.00.6"
      "com.attotech.pkg.fastframe3_exporter"
    )
    files=(
      "/usr/local/libexec/fastframe3_exporter"
    )
    user_files=(
      "%USER_HOME%/Library/Application Support/ATTO FastFrame 3"
      "%USER_HOME%/Library/Preferences/com.atto.fastframe3app.plist"
      "%USER_HOME%/Library/Caches/com.atto.fastframe3app"
      "%USER_HOME%/Library/Logs/ATTO FastFrame 3"
    )
    agents=()
    daemons=()
    profiles=()
;;
