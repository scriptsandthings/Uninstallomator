supportcompanion)
    app_name="SupportCompanion"
    bundle_id="com.github.macadmins.SupportCompanion"
    app_paths=(
      "/Applications/SupportCompanion.app"
    )
    blockingProcesses=(
      "SupportCompanion"
    )
    pkgs=(
      "com.github.macadmins.SupportCompanion"
    )
    # helper_install.zsh copies the privileged helper here from the app.
    files=(
      "/Library/PrivilegedHelperTools/com.github.macadmins.SupportCompanion.helper"
    )
    user_files=(
      "%USER_HOME%/Library/Application Support/SupportCompanion"
      "%USER_HOME%/Library/Preferences/com.github.macadmins.SupportCompanion.plist"
      "%USER_HOME%/Library/Caches/com.github.macadmins.SupportCompanion"
      "%USER_HOME%/Library/HTTPStorages/com.github.macadmins.SupportCompanion"
    )
    # The launch agent is not in the package: admins deploy it, and postinstall reloads it if present.
    agents=(
      "/Library/LaunchAgents/com.github.macadmins.SupportCompanion.agent.plist"
    )
    daemons=(
      "/Library/LaunchDaemons/com.github.macadmins.SupportCompanion.helper.plist"
    )
    profiles=()
;;
