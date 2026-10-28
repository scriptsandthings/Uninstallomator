updd)
    # Whole UPDD touch driver, not one app. The vendor's UPDD Uninstall.app is a Qt GUI that
    # elevates with AuthorizationExecuteWithPrivileges and has no documented silent flag,
    # so this label removes the files itself.
    # updd, UPDD Daemon and UPDD Commander are launchd KeepAlive jobs: they stop when their
    # plists are booted out below. Listing them in blockingProcesses would make launchd
    # restart them and the engine abort with exit 11.
    app_name="UPDD"
    bundle_id="com.touch-base.updd"
    blockingProcesses=(
      "UPDD Console"
      "UPDD Calibrate"
      "UPDD Test"
      "UPDD Annotate"
      "upddutils"
    )
    app_paths=(
      "/Library/Application Support/UPDD"
      "/Applications/Utilities/UPDD Calibrate.app"
      "/Applications/Utilities/UPDD Console.app"
      "/Applications/Utilities/UPDD Test.app"
      "/Applications/Utilities/UPDD Annotate.app"
      "/Applications/Utilities/UPDD System Extension.app"
      "/Applications/Utilities/UPDD Commander.app"
      "/Applications/Utilities/UPDD Gestures.app"
      "/Applications/Utilities/UPDD TUIO.app"
      "/Applications/Utilities/UPDD Uninstall.app"
      "/Applications/Utilities/AirBar Multi-touch.app"
    )
    pkgs=(
      "com.touch-base.pkg.updd"
      "com.touch-base.pkg.updddriverdext"
      "com.touch-base.pkg.updddrivernewformat"
      "com.touch-base.pkg.updddriverunsigned"
    )
    files=(
      "/Applications/Utilities/qt.conf"
      "/Library/Preferences/UPDD"
      "/Library/Extensions/tbupddmxhid.kext"
      "/Library/Extensions/updd.kext"
      "/Library/PreferencePanes/UPDD.prefPane"
      "/Library/PreferencePanes/AirBar.prefpane"
    )
    user_files=(
      "%USER_HOME%/Library/Preferences/com.touch-base.upddcommander.plist"
      "%USER_HOME%/Library/Preferences/com.touch-base.updd-daemon.plist"
      "%USER_HOME%/Library/Preferences/com.touch-base.UPDD-Calibrate.plist"
      "%USER_HOME%/Library/Preferences/com.touch-base.UPDD-Console.plist"
      "%USER_HOME%/Library/Preferences/com.touch-base.updd-test.plist"
      "%USER_HOME%/Library/Preferences/com.touch-base.updd-annotate.plist"
      "%USER_HOME%/Library/Caches/com.touch-base.upddcommander"
      "%USER_HOME%/Library/Caches/com.touch-base.updd-daemon"
      "%USER_HOME%/Library/Saved Application State/com.touch-base.upddcommander.savedState"
      "%USER_HOME%/Library/Saved Application State/com.touch-base.UPDD-Calibrate.savedState"
      "%USER_HOME%/Library/Saved Application State/com.touch-base.UPDD-Console.savedState"
      "%USER_HOME%/Library/Saved Application State/com.touch-base.updd-test.savedState"
      "%USER_HOME%/Library/Saved Application State/com.touch-base.updd-annotate.savedState"
    )
    agents=(
      "/Library/LaunchAgents/com.touch-base.upddcommander.plist"
      "/Library/LaunchAgents/com.touch-base.updddaemon.plist"
      "/Library/LaunchAgents/com.touch-base.aidaemon.plist"
      "/Library/LaunchAgents/com.touch-base.upddgestures.plist"
      "/Library/LaunchAgents/com.touch-base.upddtuio.plist"
    )
    daemons=(
      "/Library/LaunchDaemons/com.touch-base.updd.plist"
      "/Library/Application Support/UPDD/com.touch-base.updd-accessibility.plist"
      "/Library/LaunchDaemons/com.touch-base.tbupddwu.plist"
    )
    profiles=()
;;
