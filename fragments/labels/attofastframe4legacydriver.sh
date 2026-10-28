attofastframe4legacydriver)
    app_name="ATTO FastFrame 4 Legacy Driver"
    bundle_id="com.ATTO.driver.ATTOFastFrame4"
    # The legacy kext for Macs below macOS 15.4 (package com.atto.pkg.fastframe4k, Team ID FC94733TZD).
    # The app and the DriverKit extension are the labels attofastframe4 and attofastframe4driver and
    # are never touched here. The metrics exporter and the shared /Applications/ATTO and
    # /var/attotech/log folders belong to other ATTO packages and are left alone.
    app_paths=(
      "/Library/Extensions/ATTOFastFrame4.kext"
    )
    pkgs=(
      "com.atto.pkg.fastframe4k"
    )
    files=(
      "/Applications/ATTO/FastFrame4"
      "/usr/local/libexec/attofastframe4logd"
      "/usr/local/libexec/atto_fastframe4k_tmp"
      "/var/attotech/log/ATTOFastFrame4.log"
    )
    user_files=()
    agents=()
    daemons=(
      "/Library/LaunchDaemons/com.attotech.attofastframe4logd.plist"
    )
    profiles=()
;;
