permute)
    # Permute 4 (the Installomator label permute, bundle id com.charliemonroe.Permute-4) and the Setapp build.
    # Permute 3 is the label permute3. The app group D43XN356JM.com.charliemonroe.Permute-3 and the
    # MetadataProcessor container are shared with Permute 3, so they stay.
    app_name="Permute"
    bundle_id="com.charliemonroe.Permute-4"
    app_paths=(
      "/Applications/Permute 4.app"
      "/Applications/Setapp/Permute.app"
      "%USER_HOME%/Applications/Setapp/Permute.app"
    )
    pkgs=()
    files=()
    user_files=(
      "%USER_HOME%/Applications/Setapp/Permute.app"
      "%USER_HOME%/Library/Application Support/Permute"
      "%USER_HOME%/Library/Logs/Permute"
      "%USER_HOME%/Library/Preferences/com.charliemonroe.Permute-setapp.plist"
      "%USER_HOME%/Library/Caches/com.charliemonroe.Permute-setapp"
      "%USER_HOME%/Library/HTTPStorages/com.charliemonroe.Permute-setapp"
      "%USER_HOME%/Library/Saved Application State/com.charliemonroe.Permute-setapp.savedState"
      "%USER_HOME%/Library/Containers/com.charliemonroe.Permute-setapp"
      "%USER_HOME%/Library/Containers/com.charliemonroe.Permute-4"
      "%USER_HOME%/Library/Application Scripts/com.charliemonroe.Permute-4"
      "%USER_HOME%/Library/Preferences/com.charliemonroe.Permute-4.plist"
    )
    agents=()
    daemons=()
    profiles=()
;;
