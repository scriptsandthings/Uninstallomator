zulujdk8)
    # Azul Zulu JDK 8. One label per major version: a JDK folder is chosen by number, and a Mac can
    # carry several, so each version has its own label. Label zulujdk removes every version.
    # Receipt com.azulsystems.zulu.8 is the Installomator packageID.
    app_name="Zulu JDK 8"
    bundle_id="com.azulsystems.zulu.8"
    app_paths=(
      "/Library/Java/JavaVirtualMachines/zulu-8.jdk"
    )
    pkgs=(
      "com.azulsystems.zulu.8"
    )
    files=()
    user_files=()
    agents=()
    daemons=()
    profiles=()
;;
