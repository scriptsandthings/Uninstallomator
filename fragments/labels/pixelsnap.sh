pixelsnap)
    # Removes both builds: the Setapp copy (pl.maketheweb.pixelsnap2-setapp) and the vendor
    # direct build (pl.maketheweb.pixelsnap2) the Installomator label pixelsnap2 installs, so one
    # label clears whichever copy a Mac has. Label pixelsnap2
    # removes the direct build alone.
    app_name="PixelSnap"
    bundle_id="pl.maketheweb.pixelsnap2-setapp"
    blockingProcesses=(
      "PixelSnap 2"
    )
    app_paths=(
      "/Applications/Setapp/PixelSnap.app"
      "%USER_HOME%/Applications/Setapp/PixelSnap.app"
      "/Applications/PixelSnap 2.app"
    )
    pkgs=()
    files=()
    user_files=(
      "%USER_HOME%/Applications/Setapp/PixelSnap.app"
      "%USER_HOME%/Library/Application Support/PixelSnap"
      "%USER_HOME%/Library/Logs/PixelSnap"
      "%USER_HOME%/Library/Preferences/pl.maketheweb.pixelsnap2-setapp.plist"
      "%USER_HOME%/Library/Caches/pl.maketheweb.pixelsnap2-setapp"
      "%USER_HOME%/Library/HTTPStorages/pl.maketheweb.pixelsnap2-setapp"
      "%USER_HOME%/Library/Saved Application State/pl.maketheweb.pixelsnap2-setapp.savedState"
      "%USER_HOME%/Library/Containers/pl.maketheweb.pixelsnap2-setapp"
      "%USER_HOME%/Library/Application Support/PixelSnap 2"
      "%USER_HOME%/Library/Application Support/pl.maketheweb.pixelsnap2"
      "%USER_HOME%/Library/Preferences/pl.maketheweb.pixelsnap2.plist"
      "%USER_HOME%/Library/Caches/pl.maketheweb.pixelsnap2"
      "%USER_HOME%/Library/HTTPStorages/pl.maketheweb.pixelsnap2"
      "%USER_HOME%/Library/HTTPStorages/pl.maketheweb.pixelsnap2.binarycookies"
      "%USER_HOME%/Library/Saved Application State/pl.maketheweb.pixelsnap2.savedState"
    )
    agents=()
    daemons=()
    profiles=()
;;
