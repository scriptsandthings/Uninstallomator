displaylinkuseragent)
    app_name="DisplayLink Manager"
    bundle_id="com.displaylink.DisplayLinkUserAgent"
    app_paths=(
      "/Applications/DisplayLink Manager.app"
      "/Applications/DisplayLink End-User Cleaner.app"
    )
    pkgs=(
      "com.displaylink.displaylinkmanagerapp"
      "com.displaylink.displaylinkloginscreenext"
    )
    files=(
      "/Library/Preferences/com.displaylink.plist"
      "/Library/Application Support/DisplayLink"
      "/Library/PrivilegedHelperTools/DisplayLink"
      "/Library/Extensions/DisplayLinkDriver.kext"
      "/Library/Extensions/DisplayLinkEthernetDriver.kext"
      "/var/log/displaylink"
      "/Applications/DisplayLink Software Uninstaller.app"
    )
    user_files=(
      "%USER_HOME%/Library/Containers/com.displaylink.DisplayLinkUserAgent"
      "%USER_HOME%/Library/Containers/com.displaylink.DisplayLinkManager"
      "%USER_HOME%/Library/Containers/com.displaylink.DisplayLinkLoginHelper"
      "%USER_HOME%/Library/Containers/com.displaylink.DisplayLink Manager"
      "%USER_HOME%/Library/Group Containers/73YQY62QM3.com.displaylink.DisplayLinkShared"
      "%USER_HOME%/Library/Group Containers/com.displaylink.DisplayLinkShared"
      "%USER_HOME%/Library/Application Scripts/com.displaylink.DisplayLinkUserAgent"
      "%USER_HOME%/Library/Application Scripts/com.displaylink.DisplayLinkManager"
      "%USER_HOME%/Library/Application Scripts/com.displaylink.DisplayLinkLoginHelper"
      "%USER_HOME%/Library/Application Scripts/73YQY62QM3.com.displaylink.DisplayLinkShared"
      "%USER_HOME%/Library/Application Scripts/com.displaylink.DisplayLink_Manager"
      "%USER_HOME%/Library/Preferences/73YQY62QM3.com.displaylink.DisplayLinkShared.plist"
      "%USER_HOME%/Library/Preferences/com.displaylink.DisplayLinkUserAgent.plist"
      "%USER_HOME%/Library/Preferences/com.displaylink.displaylinkmanager.plist"
      "%USER_HOME%/Library/Preferences/com.displaylink.airdisplaypriority.plist"
      "%USER_HOME%/Library/Caches/com.displaylink.DisplayLinkUserAgent"
    )
    agents=(
      "/Library/LaunchAgents/com.displaylink.loginscreen.plist"
      "/Library/LaunchAgents/com.displaylink.useragent.plist"
      "/Library/LaunchAgents/com.displaylink.useragent-prelogin.plist"
      "/Library/LaunchAgents/73YQY62QM3.com.displaylink.DisplayLinkAPServer.plist"
    )
    daemons=(
      "/Library/LaunchDaemons/com.displaylink.displaylinkmanager.plist"
      "/Library/LaunchDaemons/com.displaylink.launchd.plist"
    )
    profiles=()
;;
