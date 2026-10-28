safaritechpreviewgoldengate)
    # Safari Technology Preview, the goldengate build. Every build installs the same app; label safaritechpreview removes any build.
    app_name="Safari Technology Preview"
    bundle_id="com.apple.SafariTechnologyPreview"
    app_paths=(
      "/Applications/Safari Technology Preview.app"
    )
    pkgs=()
    # Apple puts the release number in the receipt ID and has changed its pattern
    # (SafariTechPreview253, Safari255TechPreview), so ask pkgutil for every one.
    pkgs+=( ${(f)"$(/usr/sbin/pkgutil --pkgs='com\.apple\.pkg\.Safari.*TechPreview.*' 2>/dev/null)"} )
    files=()
    user_files=(
      "%USER_HOME%/Library/Caches/com.apple.SafariTechnologyPreview"
      "%USER_HOME%/Library/Saved Application State/com.apple.SafariTechnologyPreview.savedState"
    )
    agents=(
      "/Library/LaunchAgents/com.apple.webkit.webpushd.plist"
      "/Library/LaunchAgents/com.apple.AuthenticationServicesCore.AuthenticationServicesAgent.plist"
      "/Library/LaunchAgents/com.apple.SafariSyncService.plist"
    )
    daemons=()
    profiles=()
;;
