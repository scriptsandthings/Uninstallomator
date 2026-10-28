zoomus)
    app_name="zoom.us"
    bundle_id="us.zoom.xos"
    app_paths=(
      "/Applications/zoom.us.app"
    )
    pkgs=(
      "us.zoom.pkg.videomeeting"
    )
    files=(
      "/Library/PrivilegedHelperTools/us.zoom.ZoomDaemon"
      "/Library/Audio/Plug-Ins/HAL/ZoomAudioDevice.driver"
    )
    user_files=(
      "%USER_HOME%/Library/Application Support/zoom.us"
      "%USER_HOME%/.zoomus"
      "%USER_HOME%/Library/Preferences/us.zoom.xos.plist"
      "%USER_HOME%/Library/Preferences/ZoomChat.plist"
      "%USER_HOME%/Library/Caches/us.zoom.xos"
      "%USER_HOME%/Library/Logs/zoom.us"
      "%USER_HOME%/Library/Saved Application State/us.zoom.xos.savedState"
    )
    agents=()
    daemons=(
      "/Library/LaunchDaemons/us.zoom.ZoomDaemon.plist"
    )
    profiles=()
;;
