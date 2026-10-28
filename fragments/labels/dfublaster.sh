dfublaster)
    app_name="DFU Blaster"
    bundle_id="com.twocanoes.DFU-Blaster"
    app_paths=(
      "/Applications/DFU Blaster.app"
    )
    pkgs=(
      "com.twocanoes.pkg.DFU-Blaster"
    )
    files=(
      "/Library/PrivilegedHelperTools/com.twocanoes.dfublasterhelper"
    )
    user_files=(
      "%USER_HOME%/Library/Application Support/DFU Blaster"
      "%USER_HOME%/Library/Preferences/com.twocanoes.DFU-Blaster.plist"
      "%USER_HOME%/Library/Caches/com.twocanoes.DFU-Blaster"
      "%USER_HOME%/Library/Logs/DFU Blaster"
      "%USER_HOME%/Library/Saved Application State/com.twocanoes.DFU-Blaster.savedState"
    )
    agents=()
    daemons=(
      "/Library/LaunchDaemons/com.twocanoes.dfublasterhelper.plist"
    )
    profiles=()
    # DFU Blaster Pro shares the helper, its launch daemon and the receipt. Leave them while it is installed.
    if [[ -d "/Applications/DFU Blaster Pro.app" ]]; then
      pkgs=()
      files=()
      daemons=()
    fi
;;
