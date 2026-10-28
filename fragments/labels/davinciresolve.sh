davinciresolve)
    app_name="DaVinci Resolve"
    bundle_id="com.blackmagic-design.DaVinciResolve"
    app_paths=(
      "/Applications/DaVinci Resolve"
      "/Applications/Blackmagic Proxy Generator Lite.app"
    )
    pkgs=(
      "com.blackmagic-design.ManifestPanels"
      "com.blackmagic-design.ManifestFairlightAudioAccelerator"
      "com.blackmagic-design.ManifestLite"
      "com.blackmagic-design.DaVinciKeyboards"
      "com.blackmagic-design.DaVinciPanels"
      "com.blackmagic-design.FairlightPanels"
    )
    files=(
      "/Library/Application Support/Blackmagic Design/DaVinci Resolve Advanced Panel"
      "/Library/Application Support/Blackmagic Design/DaVinci Resolve Panels/AdminUtility"
      "/Library/Frameworks/DaVinciPanelAPI.framework"
      "/Library/Frameworks/FairlightPanelAPI.framework"
      "/Library/OFX/Plugins/DaVinci Resolve Renderer.ofx.bundle"
      "/var/tmp/davinci_socket"
    )
    user_files=(
      "%USER_HOME%/Library/Preferences/com.blackmagic-design.DaVinciResolve.plist"
      "%USER_HOME%/Library/Caches/com.blackmagic-design.DaVinciResolve"
      "%USER_HOME%/Library/Saved Application State/com.blackmagic-design.DaVinciResolve.savedState"
    )
    agents=(
      "/Library/LaunchAgents/com.blackmagic-design.DaVinciResolveBMDPanelDaemon.plist"
    )
    daemons=()
    profiles=()
;;
