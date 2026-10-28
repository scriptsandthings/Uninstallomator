attofastframe3legacydriver)
    app_name="ATTO FastFrame 3 Legacy Driver"
    bundle_id="com.ATTO.driver.ATTOFastFrame3"
    # The legacy kext for Macs below macOS 15.4 (package com.atto.pkg.fastframe3k, Team ID FC94733TZD).
    # The app and the DriverKit extension are the labels attofastframe3 and attofastframe3driver and
    # are never touched here. The metrics exporter and the shared /Applications/ATTO and
    # /var/attotech/log folders belong to other ATTO packages and are left alone.
    app_paths=(
      "/Library/Extensions/ATTOFastFrame3.kext"
    )
    pkgs=(
      "com.atto.pkg.fastframe3k"
    )
    files=(
      "/Applications/ATTO/FastFrame3"
      "/usr/local/libexec/attofastframe3logd"
      "/usr/local/libexec/atto_fastframe3k_tmp"
      "/var/attotech/log/ATTOFastFrame3.log"
    )
    user_files=()
    agents=()
    daemons=(
      "/Library/LaunchDaemons/com.attotech.attofastframe3logd.plist"
    )
    profiles=()
;;
