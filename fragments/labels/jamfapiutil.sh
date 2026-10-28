jamfapiutil)
    app_name="API Utility"
    bundle_id="org.jamfie.jamfapi"
    app_paths=(
      "/Applications/API Utility.app"
    )
    pkgs=()
    files=()
    blockingProcesses=(
      "JSK-keychain-service"
    )
    user_files=(
      "%USER_HOME%/Library/Application Support/apiutil"
      "%USER_HOME%/Library/Preferences/org.jamfie.jamfapi.plist"
      "%USER_HOME%/Library/Caches/org.jamfie.jamfapi"
      "%USER_HOME%/Library/Logs/apiutil"
      "%USER_HOME%/Library/HTTPStorages/org.jamfie.jamfapi"
      "%USER_HOME%/Library/Saved Application State/org.jamfie.jamfapi.savedState"
      "%USER_HOME%/Library/WebKit/org.jamfie.jamfapi"
      "%USER_HOME%/Library/Application Support/API Utility"
    )
    agents=()
    daemons=()
    profiles=()
;;
