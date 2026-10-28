synologydriveclient)
    app_name="Synology Drive Client"
    bundle_id="com.synology.CloudStation"
    app_paths=(
      "/Applications/Synology Drive Client.app"
    )
    pkgs=(
      "com.synology.CloudStation"
    )
    files=()
    user_files=(
      "%USER_HOME%/Library/Application Support/SynologyDrive"
      "%USER_HOME%/Library/Preferences/com.synology.CloudStationUI.plist"
      "%USER_HOME%/Library/Preferences/com.synology.CloudStation.plist"
      "%USER_HOME%/Library/Caches/com.synology.CloudStation"
      "%USER_HOME%/Library/Containers/com.synology.SynologyDrive.FinderHelper"
      "%USER_HOME%/Library/Containers/com.synology.SynologyDrive.FinderHelper.FinderSync"
      "%USER_HOME%/Library/Containers/com.synology.CloudStationUI.FileProvider"
      "%USER_HOME%/Library/Application Scripts/com.synology.SynologyDrive.FinderHelper"
      "%USER_HOME%/Library/Application Scripts/com.synology.SynologyDrive.FinderHelper.FinderSync"
      "%USER_HOME%/Library/Application Scripts/com.synology.CloudStationUI.FileProvider"
      "%USER_HOME%/Library/Application Scripts/group.com.synology.CloudStationUI"
      "%USER_HOME%/Library/Group Containers/group.com.synology.CloudStationUI"
    )
    agents=()
    daemons=()
    profiles=()
;;
