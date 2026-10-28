zulujdk15)
    # Azul Zulu JDK 15. One label per major version: a JDK folder is chosen by number, and a Mac can
    # carry several, so each version has its own label. Label zulujdk removes every version.
    # Receipt com.azulsystems.zulu.15 is the Installomator packageID.
    app_name="Zulu JDK 15"
    bundle_id="com.azulsystems.zulu.15"
    app_paths=(
      "/Library/Java/JavaVirtualMachines/zulu-15.jdk"
    )
    pkgs=(
      "com.azulsystems.zulu.15"
    )
    files=()
    user_files=()
    agents=()
    daemons=()
    profiles=()
;;
