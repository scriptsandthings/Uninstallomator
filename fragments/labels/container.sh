container)
    # Apple's own uninstall-container.sh (in the pkg) removes the payload files and the receipt, and
    # deletes ~/Library/Application Support/com.apple.container only with -d. That folder holds the
    # user's images, containers and volumes, so it stays.
    app_name="container"
    bundle_id="com.apple.container"
    app_paths=(
      "/usr/local/bin/container"
      "/usr/local/bin/container-apiserver"
      "/usr/local/libexec/container"
    )
    blockingProcesses=(
      "container-apiserver"
      "container-core-images"
      "container-network-vmnet"
      "container-runtime-linux"
    )
    pkgs=(
      "com.apple.container-installer"
    )
    files=(
      "/usr/local/bin/uninstall-container.sh"
      "/usr/local/bin/update-container.sh"
    )
    user_files=(
      "%USER_HOME%/Library/Preferences/com.apple.container.defaults.plist"
    )
    agents=()
    daemons=()
    profiles=()
;;
