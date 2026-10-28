wacomdrivers)
    app_name="Wacom Drivers"
    bundle_id="com.wacom.WacomCenter"
    app_paths=(
      "/Applications/Wacom Tablet.localized"
    )
    pkgs=(
      "com.wacom.TabletInstaller"
    )
    files=(
      "/Library/PreferencePanes/WacomCenter.prefpane"
      "/Library/PreferencePanes/WacomTablet.prefpane"
      "/Library/Application Support/Tablet"
      "/Library/PrivilegedHelperTools/com.wacom.UpdateHelper.app"
      "/Library/PrivilegedHelperTools/com.wacom.DataStoreMgr.app"
      "/Library/PrivilegedHelperTools/Wacom_IOManager.app"
      "/Library/Frameworks/WacomMultiTouch.framework"
      "/Library/DCV Extensions/WacomADCV.json"
      "/Library/Preferences/Tablet"
      "/Library/Preferences/com.wacomtablet.defaults.xml"
    )
    blockingProcesses=(
      "Wacom Center"
      "Wacom Tablet Utility"
      "Wacom Display Settings"
      "WacomTabletDriver"
      "WacomTouchDriver"
      "TabletDriver"
      "Wacom Experience Program"
    )
    user_files=(
      "%USER_HOME%/Library/Application Support/Wacom Center"
      "%USER_HOME%/Library/Preferences/com.wacom.WacomCenter.plist"
      "%USER_HOME%/Library/Caches/com.wacom.WacomCenter"
      "%USER_HOME%/Library/Logs/Wacom Center"
      "%USER_HOME%/Library/Application Support/Wacom Tablet Utility"
      "%USER_HOME%/Library/Preferences/com.wacom.RemoveWacomTablet.plist"
      "%USER_HOME%/Library/Caches/com.wacom.RemoveWacomTablet"
      "%USER_HOME%/Library/Logs/Wacom Tablet Utility"
      "%USER_HOME%/Library/Application Support/Wacom Display Settings"
      "%USER_HOME%/Library/Preferences/com.wacom.Wacom-Display-Settings.plist"
      "%USER_HOME%/Library/Caches/com.wacom.Wacom-Display-Settings"
      "%USER_HOME%/Library/Logs/Wacom Display Settings"
      "%USER_HOME%/Library/Containers/com.wacom.wacomtablet"
      "%USER_HOME%/Library/Group Containers/group.com.wacom.TabletDriver"
      "%USER_HOME%/Library/Application Support/Wacom"
    )
    agents=(
      "/Library/LaunchAgents/com.wacom.DataStoreMgr.plist"
      "/Library/LaunchAgents/com.wacom.IOManager.plist"
      "/Library/LaunchAgents/com.wacom.wacomtablet.plist"
    )
    daemons=(
      "/Library/LaunchDaemons/com.wacom.UpdateHelper.plist"
      "/Library/LaunchDaemons/com.wacom.displayhelper.plist"
    )
    profiles=()
;;
