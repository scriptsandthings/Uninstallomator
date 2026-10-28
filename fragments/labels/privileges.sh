privileges)
    app_name="Privileges"
    bundle_id="corp.sap.privileges"
    app_paths=(
      "/Applications/Privileges.app"
    )
    blockingProcesses=(
      "Privileges"
      "PrivilegesAgent"
      "PrivilegesDaemon"
      "PrivilegesWatcher"
      "PrivilegesCLI"
      "PrivilegesHelper"
    )
    pkgs=(
      "corp.sap.privileges.pkg"
    )
    files=(
      "/Library/PrivilegedHelperTools/corp.sap.privileges.helper"
      "/private/etc/paths.d/PrivilegesCLI"
      "/Library/Scripts/VoiceOver/Privileges Time Left.scpt"
    )
    user_files=(
      "%USER_HOME%/Library/Preferences/corp.sap.privileges.plist"
      "%USER_HOME%/Library/Preferences/corp.sap.privileges.agent.plist"
      "%USER_HOME%/Library/Preferences/corp.sap.privileges.docktileplugin.plist"
      "%USER_HOME%/Library/Containers/corp.sap.privileges"
      "%USER_HOME%/Library/Group Containers/7R5ZEU67FQ.corp.sap.privileges"
      "%USER_HOME%/Library/Application Scripts/corp.sap.privileges"
      "%USER_HOME%/Library/Caches/corp.sap.privileges"
      "%USER_HOME%/Library/Application Support/Privileges"
      "%USER_HOME%/Library/Logs/Privileges"
    )
    agents=(
      "/Library/LaunchAgents/corp.sap.privileges.agent.plist"
      "/Library/LaunchAgents/corp.sap.privileges.plist"
    )
    daemons=(
      "/Library/LaunchDaemons/corp.sap.privileges.daemon.plist"
      "/Library/LaunchDaemons/corp.sap.privileges.watcher.plist"
      "/Library/LaunchDaemons/corp.sap.privileges.helper.plist"
    )
    profiles=()
;;
