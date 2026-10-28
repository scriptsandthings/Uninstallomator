hooktest-ok)
    app_name="HookTest"
    bundle_id="test.hooktest"
    app_paths=( "/Applications/HookTest.app" )
    pre_remove=(
      "touch /w/out/pre.ok"
      "echo first line; echo second line"
    )
    post_remove=( "touch /w/out/post.ok" )
;;
hooktest-prefail)
    app_name="HookTest"
    bundle_id="test.hooktest"
    app_paths=( "/Applications/HookTest.app" )
    pre_remove=( "exit 3" )
    post_remove=( "touch /w/out/post.ok" )
;;
hooktest-postfail)
    app_name="HookTest"
    bundle_id="test.hooktest"
    app_paths=( "/Applications/HookTest.app" )
    post_remove=( "exit 5" )
;;
hooktest-hang)
    app_name="HookTest"
    bundle_id="test.hooktest"
    app_paths=( "/Applications/HookTest.app" )
    pre_remove=( "sleep 30; touch /w/out/hang.done" )
;;
hooktest-userhang)
    app_name="HookTest"
    bundle_id="test.hooktest"
    app_paths=( "/Applications/HookTest.app" )
    pre_remove_as_user=1
    pre_remove=( "sleep 31; touch /w/out/u/hang.done" )
;;
hooktest-absent)
    app_name="NotThere"
    bundle_id="test.notthere"
    app_paths=( "/Applications/NotThere.app" )
    pre_remove=( "touch /w/out/pre.ok" )
    post_remove=( "touch /w/out/post.ok" )
;;
hooktest-user)
    app_name="HookTest"
    bundle_id="test.hooktest"
    app_paths=( "/Applications/HookTest.app" )
    pre_remove_as_user=1
    pre_remove=( "id -un > /w/out/u/user.out" )
;;
hooktest-scalar)
    app_name="HookTest"
    bundle_id="test.hooktest"
    app_paths=( "/Applications/HookTest.app" )
    pre_remove="touch /w/out/scalar.ok"
;;
hooktest-gate)
    app_name="Gate"
    bundle_id="test.gate"
    app_paths=( "/Applications/Gate.app" )
    hook_team_id="TEAM123456"
    pre_remove=( "/Applications/Gate.app/Contents/MacOS/tool --deactivate" )
;;
hooktest-gate-user)
    app_name="Gate"
    bundle_id="test.gate"
    app_paths=( "/Applications/Gate.app" )
    hook_team_id="TEAM123456"
    pre_remove_as_user=1
    pre_remove=( "/Applications/Gate.app/Contents/MacOS/tool --deactivate" )
;;
hooktest-gate-noteam)
    app_name="Gate"
    bundle_id="test.gate"
    app_paths=( "/Applications/Gate.app" )
    pre_remove=( "/Applications/Gate.app/Contents/MacOS/tool --deactivate" )
;;
hooktest-gate-env)
    app_name="Gate"
    bundle_id="test.gate"
    app_paths=( "/Applications/Gate.app" )
    hook_team_id="TEAM123456"
    pre_remove=( "/usr/bin/env /Applications/Gate.app/Contents/MacOS/tool --wrapped" )
;;
hooktest-localbin)
    app_name="HookTest"
    bundle_id="test.hooktest"
    app_paths=( "/Applications/HookTest.app" )
    pre_remove=( "/usr/local/bin/hooktool --local" )
;;
hooktest-dotdot)
    app_name="HookTest"
    bundle_id="test.hooktest"
    app_paths=( "/Applications/HookTest.app" )
    pre_remove=( "/usr/bin/../../usr/local/bin/hooktool --dotdot" )
;;
hooktest-syspath)
    app_name="HookTest"
    bundle_id="test.hooktest"
    app_paths=( "/Applications/HookTest.app" )
    pre_remove=( "/bin/touch /w/out/sys.ok" )
;;
hooktest-chain)
    app_name="HookTest"
    bundle_id="test.hooktest"
    app_paths=( "/Applications/HookTest.app" )
    pre_remove=( "touch /w/out/chain.first; /usr/local/bin/hooktool --chained" )
;;
hooktest-vendorgone)
    app_name="HookTest"
    bundle_id="test.hooktest"
    app_paths=( "/Applications/HookTest.app" )
    files=( "/w/leftover" )
    pre_remove=( "rm -rf /Applications/HookTest.app" )
    post_remove=( "touch /w/out/post.ok" )
;;
hooktest-userhome)
    app_name="HookTest"
    bundle_id="test.hooktest"
    app_paths=( "%USER_HOME%/Applications/HookTest.app" )
    pre_remove=( "touch /w/out/pre.ok" )
;;
