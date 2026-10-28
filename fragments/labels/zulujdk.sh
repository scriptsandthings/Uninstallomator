zulujdk)
    # Every Azul Zulu JDK major version. Labels zulujdk8, zulujdk11, zulujdk13, zulujdk15 and zulujdk21 remove one.
    app_name="Zulu JDK"
    bundle_id="com.azulsystems.zulu.21"
    app_paths=(
      "/Library/Java/JavaVirtualMachines/zulu-21.jdk"
      "/Library/Java/JavaVirtualMachines/zulu-15.jdk"
      "/Library/Java/JavaVirtualMachines/zulu-13.jdk"
      "/Library/Java/JavaVirtualMachines/zulu-11.jdk"
      "/Library/Java/JavaVirtualMachines/zulu-8.jdk"
    )
    pkgs=(
      "com.azulsystems.zulu.21"
      "com.azulsystems.zulu.15"
      "com.azulsystems.zulu.13"
      "com.azulsystems.zulu.11"
      "com.azulsystems.zulu.8"
    )
    files=()
    user_files=()
    agents=()
    daemons=()
    profiles=()
;;
