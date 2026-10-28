automounter)
    app_name="AutoMounter"
    bundle_id="nz.co.pixeleyes.AutoMounter"
    app_paths=(
      "/Applications/AutoMounter.app"
    )
    pkgs=()
    files=()
    user_files=(
      "%USER_HOME%/Library/Application Support/AutoMounter"
      "%USER_HOME%/Library/Preferences/nz.co.pixeleyes.AutoMounter.plist"
      "%USER_HOME%/Library/Caches/nz.co.pixeleyes.AutoMounter"
      "%USER_HOME%/Library/Logs/AutoMounter"
    )
    agents=()
    daemons=()
    profiles=()
    # Free the licence seat before the app goes. Runs as root:
    # the binary's own strings name a machine-wide licence folder, /Users/Shared/AutoMounter.
    # Root runs a binary from inside the bundle, so the engine first checks that the bundle is
    # signed by Pixeleyes Ltd (Team ID from the Developer ID certificate in AutoMounter.dmg 1.14.1)
    # and that no standard user could have replaced it.
    hook_team_id="UKWABN4MGL"
    pre_remove=(
      "/Applications/AutoMounter.app/Contents/MacOS/AutoMounter --deactivate"
    )
;;
