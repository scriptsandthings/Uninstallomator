tableaudesktop)
    # Every version of Tableau Desktop. Labels tableaudesktop2024, tableaudesktop2025 and tableaudesktop2026 remove one year.
    app_name="Tableau Desktop"
    bundle_id="com.tableausoftware.tableaudesktop"
    app_paths=(
      "/Applications/Tableau Desktop "*.app(N/)
    )
    blockingProcesses=(
      "Tableau Desktop"
    )
    pkgs=(
      "com.tableausoftware.Desktop.app"
      "com.tableausoftware.DesktopShortcut"
      "com.tableausoftware.extensions"
      "com.tableausoftware.networkExtensions"
      "com.tableausoftware.telemetry"
    )
    # Tableau 2024 and older also install a FLEXNet licensing receipt whose ID carries its version.
    pkgs+=( ${(f)"$(/usr/sbin/pkgutil --pkgs='com\.tableausoftware\.FLEXNet\..*' 2>/dev/null)"} )
    files=(
      "/Library/Preferences/com.tableau.Tableau-"*.plist(N.)
    )
    user_files=(
      "%USER_HOME%/Library/Tableau"
      "%USER_HOME%/Library/Application Support/Tableau"
      "%USER_HOME%/Library/Preferences/com.tableausoftware.tableaudesktop.plist"
      "%USER_HOME%/Library/Preferences/com.tableau.Tableau-2024.1.plist"
      "%USER_HOME%/Library/Preferences/com.tableau.Tableau-2024.2.plist"
      "%USER_HOME%/Library/Preferences/com.tableau.Tableau-2024.3.plist"
      "%USER_HOME%/Library/Preferences/com.tableau.Tableau-2024.4.plist"
      "%USER_HOME%/Library/Preferences/com.tableau.Tableau-2025.1.plist"
      "%USER_HOME%/Library/Preferences/com.tableau.Tableau-2025.2.plist"
      "%USER_HOME%/Library/Preferences/com.tableau.Tableau-2025.3.plist"
      "%USER_HOME%/Library/Preferences/com.tableau.Tableau-2025.4.plist"
      "%USER_HOME%/Library/Preferences/com.tableau.Tableau-2026.1.plist"
      "%USER_HOME%/Library/Preferences/com.tableau.Tableau-2026.2.plist"
      "%USER_HOME%/Library/Preferences/com.tableau.Tableau-2026.3.plist"
      "%USER_HOME%/Library/Preferences/com.tableau.Tableau-2026.4.plist"
      "%USER_HOME%/Library/Caches/com.tableausoftware.tableaudesktop"
      "%USER_HOME%/Library/Logs/Tableau"
    )
    agents=()
    daemons=()
    profiles=()
;;
