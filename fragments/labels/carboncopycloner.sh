carboncopycloner)
    app_name="Carbon Copy Cloner"
    bundle_id="com.bombich.ccc"
    app_paths=(
      "/Applications/Carbon Copy Cloner.app"
    )
    pkgs=()
    files=(
      "/Library/Application Support/com.bombich.ccc"
      "/Library/PrivilegedHelperTools/com.bombich.ccchelper"
    )
    user_files=(
      "%USER_HOME%/Library/Application Support/com.bombich.ccc"
      "%USER_HOME%/Library/Application Support/CCC Stats Service"
      "%USER_HOME%/Library/Preferences/com.bombich.ccc.plist"
      "%USER_HOME%/Library/Caches/com.bombich.ccc"
      "%USER_HOME%/Library/Caches/com.bombich.ccc.stats"
      "%USER_HOME%/Library/Caches/com.bombich.cccdashboard"
      "%USER_HOME%/Library/Caches/com.bombich.cccuseragent"
    )
    agents=()
    daemons=(
      "/Library/LaunchDaemons/com.bombich.ccchelper.plist"
    )
    profiles=()
;;
