dropbox)
    app_name="Dropbox"
    bundle_id="com.getdropbox.dropbox"
    app_paths=(
      "/Applications/Dropbox.app"
    )
    pkgs=()
    files=(
      "/Library/PrivilegedHelperTools/com.getdropbox.dropbox.UpdaterPrivilegedHelper"
      "/Library/DropboxHelperTools"
    )
    user_files=(
      "%USER_HOME%/.dropbox"
      "%USER_HOME%/Library/Dropbox"
      "%USER_HOME%/Library/Application Support/Dropbox"
      "%USER_HOME%/Library/Preferences/com.getdropbox.dropbox.plist"
      "%USER_HOME%/Library/Caches/com.getdropbox.dropbox"
      "%USER_HOME%/Library/HTTPStorages/com.getdropbox.dropbox"
      "%USER_HOME%/Library/Logs/Dropbox"
      "%USER_HOME%/Library/Group Containers/G7HH3F8CAK.com.getdropbox.dropbox"
      "%USER_HOME%/Library/LaunchAgents/com.dropbox.DropboxMacUpdate.agent.plist"
      "%USER_HOME%/Library/Saved Application State/com.getdropbox.dropbox.savedState"
    )
    agents=()
    daemons=(
      "/Library/LaunchDaemons/com.getdropbox.dropbox.UpdaterPrivilegedHelper.plist"
    )
    profiles=()
;;
