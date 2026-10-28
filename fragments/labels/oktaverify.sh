oktaverify)
    app_name="Okta Verify"
    bundle_id="com.okta.mobile"
    app_paths=(
      "/Applications/Okta Verify.app"
    )
    pkgs=(
      "com.okta.mobile"
    )
    files=(
      "/usr/local/bin/OktaDAServiceDaemon"
      "/usr/local/bin/AutoUpdateDaemon"
      "/Library/Application Support/com.okta.authentication.service"
      "/Library/Application Support/com.okta.autoupdate.daemon"
    )
    user_files=(
      "%USER_HOME%/Library/Preferences/com.okta.mobile.plist"
      "%USER_HOME%/Library/Caches/com.okta.mobile"
      "%USER_HOME%/Library/Logs/Okta Verify"
      "%USER_HOME%/Library/HTTPStorages/com.okta.mobile"
      "%USER_HOME%/Library/Saved Application State/com.okta.mobile.savedState"
      "%USER_HOME%/Library/Containers/com.okta.mobile.auth-service-extension"
    )
    agents=()
    daemons=(
      "/Library/LaunchDaemons/com.okta.authentication.service.plist"
      "/Library/LaunchDaemons/com.okta.deviceaccess.servicedaemon.plist"
      "/Library/LaunchDaemons/com.okta.autoupdate.daemon.plist"
    )
    profiles=()
;;
