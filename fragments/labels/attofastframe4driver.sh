attofastframe4driver)
    # Intended: the app label and the driver label both delete the app. The DriverKit extension lives inside the app bundle, so the app is the only thing to remove. Not a lookalike overlap.
    app_name="ATTO FastFrame 4 Driver"
    bundle_id="com.atto.fastframe4driver"
    # The DriverKit extension com.atto.fastframe4driver (Team ID FC94733TZD) is carried by the app.
    # Removing the app is the removal. The legacy kext is the label attofastframe4legacydriver and is
    # never touched here.
    app_paths=(
      "/Applications/ATTO FastFrame 4.app"
    )
    pkgs=(
      "com.atto.fastframe4d.atto360n"
      "attofastframe4v1.00.7"
    )
    files=()
    user_files=(
      "%USER_HOME%/Library/Application Support/ATTO FastFrame 4"
      "%USER_HOME%/Library/Preferences/com.atto.fastframe4app.plist"
      "%USER_HOME%/Library/Caches/com.atto.fastframe4app"
      "%USER_HOME%/Library/Logs/ATTO FastFrame 4"
    )
    agents=()
    daemons=()
    profiles=()
    # What the user sees: nothing at the moment of removal. The app is deleted. macOS keeps the extension
    # registered and lists it as terminated waiting to uninstall on reboot, then drops it at the next
    # restart. No deactivation command is run: systemextensionsctl uninstall fails with SIP on. This
    # matches the UPDD labels.
;;
