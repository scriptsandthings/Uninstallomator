awsvpnclient)
    app_name="AWS VPN Client"
    bundle_id="com.amazonaws.acvc.osx"
    app_paths=(
      "/Applications/AWS VPN Client"
    )
    pkgs=(
      "com.amazon.awsvpnclient"
    )
    files=(
      "/usr/local/bin/aws-vpn-client"
      "/Library/Application Support/AWSVPNClient"
    )
    user_files=(
      "%USER_HOME%/Library/Application Support/AWS VPN Client"
      "%USER_HOME%/Library/Preferences/com.amazonaws.acvc.osx.plist"
      "%USER_HOME%/Library/Caches/com.amazonaws.acvc.osx"
      "%USER_HOME%/Library/HTTPStorages/com.amazonaws.acvc.osx"
      "%USER_HOME%/Library/Saved Application State/com.amazonaws.acvc.osx.savedState"
      "%USER_HOME%/Library/Logs/AWS VPN Client"
    )
    agents=()
    daemons=(
      "/Library/LaunchDaemons/com.amazonaws.acvc.osx.core.plist"
    )
    profiles=()
;;
