adobeacrobatreader)
    app_name="Acrobat Reader"
    bundle_id="com.adobe.Reader"
    app_paths=(
      "/Applications/Adobe Acrobat Reader.app"
    )
    blockingProcesses=(
      "AdobeReader"
    )
    pkgs=(
      "com.adobe.acrobat.DC.reader.app.pkg.MUI"
      "com.adobe.acrobat.DC.reader.appsupport.pkg.MUI"
      "com.adobe.acrobat.DC.reader.acropython3.pkg.MUI"
      "com.adobe.RdrServicesUpdater"
      "com.adobe.acrobat.DC.reader.entryPackage.pkg.MUI"
      "com.adobe.acrobat.DC.reader.exitPackage.pkg.MUI"
    )
    files=(
      "/Library/Application Support/Adobe/Reader"
      "/Library/Application Support/Adobe/WebExtnUtils/DC_Reader"
    )
    user_files=(
      "%USER_HOME%/Library/Preferences/com.adobe.Reader.plist"
      "%USER_HOME%/Library/Caches/com.adobe.Reader"
      "%USER_HOME%/Library/Saved Application State/com.adobe.Reader.savedState"
    )
    agents=()
    daemons=()
    profiles=()
;;
