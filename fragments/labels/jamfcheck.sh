jamfcheck)
    app_name="JamfCheck"
    bundle_id="com.txhaflaire.JamfCheck"
    app_paths=(
      "/Applications/jamfcheck.app"
    )
    blockingProcesses=(
      "jamfcheck"
    )
    pkgs=()
    files=(
      "/tmp/jamfcheck.helper.log"
    )
    user_files=(
      "%USER_HOME%/Library/Application Support/JamfCheck"
      "%USER_HOME%/Library/Preferences/com.txhaflaire.JamfCheck.plist"
      "%USER_HOME%/Library/Caches/com.txhaflaire.JamfCheck"
      "%USER_HOME%/Library/Logs/JamfCheck"
      "%USER_HOME%/Library/HTTPStorages/com.txhaflaire.JamfCheck"
      "%USER_HOME%/Library/Saved Application State/com.txhaflaire.JamfCheck.savedState"
      "%USER_HOME%/Library/WebKit/com.txhaflaire.JamfCheck"
    )
    agents=()
    daemons=()
    profiles=()
;;
