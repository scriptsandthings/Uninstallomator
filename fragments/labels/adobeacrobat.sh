adobeacrobat)
    app_name="Acrobat"
    bundle_id="com.adobe.Acrobat.Pro"
    app_paths=(
      "/Applications/Adobe Acrobat DC"
      "/Applications/Adobe Acrobat Next Pro"
    )
    pkgs=(
      "com.adobe.acrobat.DC.viewer.app.pkg.MUI"
      "com.adobe.acrobat.DC.viewer.appsupport.pkg.MUI"
      "com.adobe.acrobat.DC.viewer.preinstall.pkg.MUI"
      "com.adobe.acrobat.DC.viewer.print_automator.pkg.MUI"
      "com.adobe.acrobat.DC.viewer.print_pdf_services.pkg.MUI"
    )
    files=(
      "/Library/Application Support/Adobe/Acrobat"
      "/Library/Application Support/Adobe/Acrobat DC Helper Frameworks"
      "/Library/Application Support/Adobe/Acrobat DC AMT"
      "/Library/Application Support/Adobe/MACPDFM"
      "/Library/Application Support/Adobe/Adobe PDF"
    )
    user_files=(
      "%USER_HOME%/Library/Preferences/com.adobe.Acrobat.Pro.plist"
      "%USER_HOME%/Library/Caches/com.adobe.Acrobat.Pro"
      "%USER_HOME%/Library/Logs/Adobe/Acrobat"
    )
    agents=()
    daemons=()
    profiles=()
;;
