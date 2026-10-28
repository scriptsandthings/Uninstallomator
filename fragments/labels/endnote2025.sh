endnote2025)
    # EndNote 2025 (22.x) installs the folder /Applications/EndNote. EndNote 20 and 21 use the same bundle id
    # com.ThomsonResearchSoft.EndNote, so the shared files below are only removed when neither is installed.
    app_name="EndNote 2025"
    bundle_id="com.ThomsonResearchSoft.EndNote"
    app_paths=(
      "/Applications/EndNote"
    )
    pkgs=()
    files=(
      "/Library/Application Support/ResearchSoft/EndNote"
    )
    user_files=(
      "%USER_HOME%/Library/Application Support/EndNote"
      "%USER_HOME%/Library/Preferences/com.ThomsonResearchSoft.EndNote.plist"
      "%USER_HOME%/Library/Preferences/com.ThomsonReuters.EndNoteCustomizer.plist"
      "%USER_HOME%/Library/Caches/com.ThomsonResearchSoft.EndNote"
      "%USER_HOME%/Library/Cookies/com.ThomsonResearchSoft.EndNote.binarycookies"
      "%USER_HOME%/Library/HTTPStorages/com.ThomsonResearchSoft.EndNote"
      "%USER_HOME%/Library/HTTPStorages/com.ThomsonResearchSoft.EndNote.binarycookies"
      "%USER_HOME%/Library/Services/ENService.app"
      "%USER_HOME%/Library/Spotlight/EndNote.mdimporter"
      "%USER_HOME%/Library/WebKit/com.ThomsonResearchSoft.EndNote"
    )
    agents=()
    daemons=()
    profiles=()
    if [[ -d "/Applications/EndNote 20" || -d "/Applications/EndNote 21" ]]; then
      files=()
      user_files=()
    fi
;;
