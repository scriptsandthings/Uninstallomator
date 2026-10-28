fenderuniversalcontrol)
    app_name="Universal Control"
    # Version 5 (Fender) is com.fender.ucapp; PreSonus builds were com.presonus.ucapp.
    bundle_id="com.fender.ucapp"
    app_paths=(
      "/Applications/Universal Control.app"
      "/Applications/Universal Control AI.app"
      "/Applications/UniversalControl.app"
    )
    pkgs=(
      "presonus.pkg.Universal.Control.controlpanel"
      "presonus.pkg.Universal.Control.daemon"
      "presonus.pkg.Universal.Control.presets"
      "presonus.pkg.Universal.Control.tb_driver"
      "presonus.pkg.Universal.Control.audio_driver"
      "presonus.pkg.Universal.Control.midi_driver"
      "presonus.pkg.Universal.Control.fw_audio_driver"
      "presonus.pkg.Universal.Control.fw_midi_driver"
      "presonus.pkg.Universal.Control.tb_audio_driver"
      "presonus.pkg.Universal.Control.tb_midi_driver"
      "presonus.pkg.Universal.Control.AI.controlpanel"
      "presonus.pkg.Universal.Control.AI.audio_driver"
      "presonus.pkg.Universal.Control.AI.midi_driver"
      "presonus.pkg.Universal.Control.AI.presets"
      "com.presonus.pkg.universalcontrol"
      "com.presonus.ucapp"
      "com.fender.ucapp"
    )
    files=(
      "/Library/Application Support/PreSonus/universalcontrol"
      "/Library/Application Support/PreSonus/OBSRemoteAdapter"
      "/Library/Application Support/PreSonus/Offline Editor"
      "/Library/Application Support/PreSonus/Revelator Series"
      "/Library/Application Support/PreSonus/Studio 192"
      "/Library/Application Support/obs-studio/plugins/ucobscontrolplugin"
      "/Library/Audio/MIDI Drivers/UCMIDIDriver.plugin"
      "/Library/Audio/MIDI Drivers/quantum_midi_plug_in.plugin"
      "/Library/Audio/Plug-Ins/HAL/quantum_audio_plug_in.driver"
      "/Library/Extensions/quantum_driver.kext"
    )
    user_files=(
      "%USER_HOME%/Library/Application Support/Fender/Universal Control"
      "%USER_HOME%/Library/Application Support/PreSonus/Universal Control"
      "%USER_HOME%/Library/Application Support/PreSonus/Universal Control AI"
      "%USER_HOME%/Library/Application Support/PreSonus/universalcontrol"
      "%USER_HOME%/Library/Application Support/Universal Control"
      "%USER_HOME%/Library/Preferences/Fender/Universal Control"
      "%USER_HOME%/Library/Preferences/PreSonus/Universal Control"
      "%USER_HOME%/Library/Preferences/PreSonus/Universal Control (x64)"
      "%USER_HOME%/Library/Preferences/com.fender.ucapp.plist"
      "%USER_HOME%/Library/Preferences/com.presonus.ucapp.plist"
      "%USER_HOME%/Library/Caches/Juce/Universal Control"
      "%USER_HOME%/Library/Caches/Juce/jucAppLock_Universal Control"
      "%USER_HOME%/Library/Caches/com.fender.ucapp"
      "%USER_HOME%/Library/Caches/com.presonus.ucapp"
      "%USER_HOME%/Library/HTTPStorages/com.fender.ucapp"
      "%USER_HOME%/Library/HTTPStorages/com.presonus.ucapp"
      "%USER_HOME%/Library/Saved Application State/com.fender.ucapp.savedState"
      "%USER_HOME%/Library/Saved Application State/com.presonus.ucapp.savedState"
      "%USER_HOME%/Library/Logs/Universal Control"
    )
    agents=()
    daemons=(
      "/Library/LaunchDaemons/com.presonus.ucdaemon.plist"
    )
    profiles=()
;;
