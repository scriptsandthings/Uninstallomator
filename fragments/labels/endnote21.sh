endnote21)
    app_name="EndNote 21"
    bundle_id="com.ThomsonResearchSoft.EndNote"
    app_paths=(
      "/Applications/EndNote 21"
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
    if [[ -d "/Applications/EndNote 20" || -d "/Applications/EndNote" ]]; then
      files=()
      user_files=()
    fi
;;
