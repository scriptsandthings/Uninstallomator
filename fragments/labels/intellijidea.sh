intellijidea)
    # From 2025.3 JetBrains ships one "IntelliJ IDEA.app" (com.jetbrains.intellij); Community 2025.2 and
    # older is "IntelliJ IDEA CE.app" (com.jetbrains.intellij.ce). Either, or both, may be on a Mac.
    app_name="IntelliJ IDEA"
    bundle_id="com.jetbrains.intellij"
    app_paths=(
      "/Applications/IntelliJ IDEA.app"
      "/Applications/IntelliJ IDEA CE.app"
    )
    blockingProcesses=(
      "idea"
    )
    pkgs=()
    files=()
    user_files=(
      "%USER_HOME%/Library/Preferences/com.jetbrains.intellij.plist"
      "%USER_HOME%/Library/Saved Application State/com.jetbrains.intellij.savedState"
      "%USER_HOME%/Library/Caches/JetBrains/IntelliJIdea2025.3"
      "%USER_HOME%/Library/Logs/JetBrains/IntelliJIdea2025.3"
      "%USER_HOME%/Library/Caches/JetBrains/IntelliJIdea2026.1"
      "%USER_HOME%/Library/Logs/JetBrains/IntelliJIdea2026.1"
      "%USER_HOME%/Library/Caches/JetBrains/IntelliJIdea2026.2"
      "%USER_HOME%/Library/Logs/JetBrains/IntelliJIdea2026.2"
      "%USER_HOME%/Library/Preferences/com.jetbrains.intellij.ce.plist"
      "%USER_HOME%/Library/Saved Application State/com.jetbrains.intellij.ce.savedState"
      "%USER_HOME%/Library/Caches/JetBrains/IdeaIC2025.2"
      "%USER_HOME%/Library/Logs/JetBrains/IdeaIC2025.2"
      "%USER_HOME%/Library/Caches/JetBrains/IdeaIC2025.1"
      "%USER_HOME%/Library/Logs/JetBrains/IdeaIC2025.1"
    )
    agents=()
    daemons=()
    profiles=()
;;
