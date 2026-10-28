docker)
    app_name="Docker"
    bundle_id="com.docker.docker"
    app_paths=(
      "/Applications/Docker.app"
    )
    blockingProcesses=(
      "Docker Desktop"
    )
    pkgs=()
    files=(
      "/Library/PrivilegedHelperTools/com.docker.vmnetd"
      "/Library/PrivilegedHelperTools/com.docker.socket"
    )
    user_files=(
      "%USER_HOME%/Library/Application Support/Docker Desktop"
      "%USER_HOME%/Library/Application Support/com.docker.docker"
      "%USER_HOME%/Library/Containers/com.docker.helper"
      "%USER_HOME%/Library/Group Containers/group.com.docker"
      "%USER_HOME%/Library/Application Scripts/group.com.docker"
      "%USER_HOME%/Library/Application Scripts/com.docker.helper"
      "%USER_HOME%/Library/Caches/com.docker.docker"
      "%USER_HOME%/Library/Caches/Docker Desktop"
      "%USER_HOME%/Library/HTTPStorages/com.docker.docker"
      "%USER_HOME%/Library/Logs/Docker Desktop"
      "%USER_HOME%/Library/Preferences/com.docker.docker.plist"
      "%USER_HOME%/Library/Preferences/com.electron.dockerdesktop.plist"
      "%USER_HOME%/Library/Saved Application State/com.electron.dockerdesktop.savedState"
    )
    agents=()
    daemons=(
      "/Library/LaunchDaemons/com.docker.vmnetd.plist"
      "/Library/LaunchDaemons/com.docker.socket.plist"
    )
    profiles=()
;;
