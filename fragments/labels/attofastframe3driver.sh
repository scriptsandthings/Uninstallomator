attofastframe3driver)
    # Intended: the app label and the driver label both delete the app. The DriverKit extension lives inside the app bundle, so the app is the only thing to remove. Not a lookalike overlap.
    app_name="ATTO FastFrame 3 Driver"
    bundle_id="com.atto.fastframe3driver"
    # The DriverKit extension com.atto.fastframe3driver (Team ID FC94733TZD) is carried by the app.
    # Removing the app is the removal. The legacy kext is the label attofastframe3legacydriver and is
    # never touched here.
    app_paths=(
      "/Applications/ATTO FastFrame 3.app"
    )
    pkgs=(
      "com.atto.fastframe3d.atto360n"
      "attofastframe3v1.00.3"
      "attofastframe3v1.00.6"
    )
    files=()
    user_files=(
      "%USER_HOME%/Library/Application Support/ATTO FastFrame 3"
      "%USER_HOME%/Library/Preferences/com.atto.fastframe3app.plist"
      "%USER_HOME%/Library/Caches/com.atto.fastframe3app"
      "%USER_HOME%/Library/Logs/ATTO FastFrame 3"
    )
    agents=()
    daemons=()
    profiles=()
    # What the user sees: nothing at the moment of removal. The app is deleted. macOS keeps the extension
    # registered and lists it as terminated waiting to uninstall on reboot, then drops it at the next
    # restart. No deactivation command is run: systemextensionsctl uninstall fails with SIP on. This
    # matches the UPDD labels.
;;
