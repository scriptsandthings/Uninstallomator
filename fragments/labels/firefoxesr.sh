firefoxesr)
    # Release and ESR both install /Applications/Firefox.app with bundle org.mozilla.firefox. The build says which
    # it is: application.ini names the source repository, mozilla-esr<N> for ESR.
    # A release install belongs to the firefox label.
    if [[ -d "/Applications/Firefox.app" ]] && ! /usr/bin/grep -qs "mozilla-esr" "/Applications/Firefox.app/Contents/Resources/application.ini"; then
      cleanupAndExit 0 "Firefox.app is not the ESR build; nothing removed. Use the firefox label for it" WARN
    fi
    app_name="Firefox ESR"
    bundle_id="org.mozilla.firefox"
    app_paths=(
      "/Applications/Firefox.app"
    )
    blockingProcesses=(
      "firefox"
    )
    pkgs=(
      "org.mozilla.firefox"
    )
    files=()
    user_files=(
      "%USER_HOME%/Library/Preferences/org.mozilla.firefox.plist"
      "%USER_HOME%/Library/Caches/Firefox"
      "%USER_HOME%/Library/Caches/org.mozilla.firefox"
      "%USER_HOME%/Library/Logs/Firefox"
      "%USER_HOME%/Library/Saved Application State/org.mozilla.firefox.savedState"
    )
    agents=()
    daemons=()
    profiles=()
;;
