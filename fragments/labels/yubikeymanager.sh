yubikeymanager)
    app_name="YubiKey Manager"
    bundle_id="com.yubico.ykman"
    app_paths=(
      "/Applications/YubiKey Manager.app"
      "/usr/local/ykman"
    )
    pkgs=(
      "com.yubico.ykman"
      "com.yubico.yubikey-manager"
    )
    files=(
      "/usr/local/ykman"
      "/usr/local/bin/ykman"
    )
    user_files=(
      "%USER_HOME%/Library/Application Support/YubiKey Manager"
      "%USER_HOME%/Library/Preferences/com.yubico.ykman.plist"
      "%USER_HOME%/Library/Caches/com.yubico.ykman"
      "%USER_HOME%/Library/Logs/YubiKey Manager"
      "%USER_HOME%/Library/HTTPStorages/com.yubico.ykman"
      "%USER_HOME%/Library/Saved Application State/com.yubico.ykman.savedState"
      "%USER_HOME%/Library/WebKit/com.yubico.ykman"
      "%USER_HOME%/Library/Preferences/com.yubico.YubiKey Manager.plist"
    )
    agents=()
    daemons=()
    profiles=()
;;
