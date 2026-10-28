quarto)
    app_name="quarto"
    bundle_id="org.rstudio.quarto"
    # The package installs the quarto folder; its postinstall (run as root) adds the PATH entry,
    # the command link and the man page link below.
    app_paths=(
      "/Applications/quarto"
    )
    pkgs=(
      "org.rstudio.quarto"
    )
    files=(
      "/usr/local/bin/quarto"
      "/usr/local/man/quarto.1"
      "/etc/paths.d/quarto"
    )
    user_files=()
    agents=()
    daemons=()
    profiles=()
;;
