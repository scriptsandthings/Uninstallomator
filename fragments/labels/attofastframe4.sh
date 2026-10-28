attofastframe4)
    # Intended: the app label and the driver label both delete the app. The DriverKit extension lives inside the app bundle, so the app is the only thing to remove. Not a lookalike overlap.
    # The legacy kext and the DriverKit-only removal are the labels attofastframe4legacydriver and attofastframe4driver.
    app_name="ATTO FastFrame 4"
    bundle_id="com.atto.fastframe4app"
    app_paths=(
      "/Applications/ATTO FastFrame 4.app"
    )
    pkgs=(
      "com.atto.fastframe4d.atto360n"
      "attofastframe4v1.00.7"
      "com.attotech.pkg.fastframe4_exporter"
    )
    files=(
      "/usr/local/libexec/fastframe4_exporter"
    )
    user_files=(
      "%USER_HOME%/Library/Application Support/ATTO FastFrame 4"
      "%USER_HOME%/Library/Preferences/com.atto.fastframe4app.plist"
      "%USER_HOME%/Library/Caches/com.atto.fastframe4app"
      "%USER_HOME%/Library/Logs/ATTO FastFrame 4"
    )
    agents=()
    daemons=()
    profiles=()
;;
