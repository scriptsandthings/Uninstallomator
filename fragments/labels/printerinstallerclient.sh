printerinstallerclient)
    app_name="PrinterInstallerClient"
    bundle_id="com.printerlogic.PrinterInstallerClient"
    app_paths=(
      "/Applications/PrinterInstallerClient.app"
      "/Library/Application Support/Vasion/PrinterInstallerClient/service_interface/PrinterInstallerClient.app"
    )
    pkgs=(
      "com.printerlogic.client.setup.arm64"
      "com.printerlogic.client.setup.x86_64"
    )
    files=(
      "/Library/Application Support/Vasion/PrinterInstallerClient"
      "/Library/Application Support/Vasion/pl_preinstall/PrinterInstallerClient"
      "/opt/PrinterInstallerClient"
      "/private/etc/pl_dir"
    )
    user_files=(
      "%USER_HOME%/Library/Preferences/com.printerlogic.PrinterInstallerClient.plist"
      "%USER_HOME%/Library/Caches/com.printerlogic.PrinterInstallerClient"
      "%USER_HOME%/Library/Saved Application State/com.printerlogic.PrinterInstallerClient.savedState"
    )
    agents=()
    daemons=(
      "/Library/LaunchDaemons/com.printerlogic.client.plist"
    )
    profiles=()
    pre_remove=(
      "'/Library/Application Support/Vasion/PrinterInstallerClient/service_interface/PrinterInstallerClientService' uninstall"
    )
;;
