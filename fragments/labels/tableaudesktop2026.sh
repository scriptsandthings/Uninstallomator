tableaudesktop2026)
    # Every Tableau Desktop 2026 release (2026.1, 2026.2, ...). Label tableaudesktop removes every year.
    app_name="Tableau Desktop 2026"
    bundle_id="com.tableausoftware.tableaudesktop"
    app_paths=(
      "/Applications/Tableau Desktop "2026.*.app(N/)
      "/Applications/Tableau Desktop (Apple silicon) "2026.*.app(N/)
    )
    blockingProcesses=(
      "Tableau Desktop"
    )
    pkgs=()
    files=(
      "/Library/Preferences/com.tableau.Tableau-"2026.*.plist(N.)
    )
    user_files=(
      "%USER_HOME%/Library/Preferences/com.tableau.Tableau-2026.1.plist"
      "%USER_HOME%/Library/Preferences/com.tableau.Tableau-2026.2.plist"
      "%USER_HOME%/Library/Preferences/com.tableau.Tableau-2026.3.plist"
      "%USER_HOME%/Library/Preferences/com.tableau.Tableau-2026.4.plist"
    )
    # Every year shares the receipts and files below. Leave them while another year is still installed.
    other_versions=( "/Applications/Tableau Desktop "*.app(N/) )
    other_versions=( ${other_versions:#"/Applications/Tableau Desktop "2026.*.app} )
    other_versions=( ${other_versions:#"/Applications/Tableau Desktop (Apple silicon) "2026.*.app} )
    if (( ${#other_versions} == 0 )); then
      pkgs+=(
        "com.tableausoftware.Desktop.app"
        "com.tableausoftware.DesktopShortcut"
        "com.tableausoftware.extensions"
        "com.tableausoftware.networkExtensions"
        "com.tableausoftware.telemetry"
      )
      # Tableau 2024 and older also install a FLEXNet licensing receipt whose ID carries its version.
      pkgs+=( ${(f)"$(/usr/sbin/pkgutil --pkgs='com\.tableausoftware\.FLEXNet\..*' 2>/dev/null)"} )
      user_files+=(
        "%USER_HOME%/Library/Tableau"
        "%USER_HOME%/Library/Application Support/Tableau"
        "%USER_HOME%/Library/Preferences/com.tableausoftware.tableaudesktop.plist"
        "%USER_HOME%/Library/Caches/com.tableausoftware.tableaudesktop"
        "%USER_HOME%/Library/Logs/Tableau"
      )
    fi
    agents=()
    daemons=()
    profiles=()
;;
