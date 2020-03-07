#!/usr/bin/env ./test/libs/bats/bin/bats
load 'libs/bats-support/load'
load 'libs/bats-assert/load'

factorio_script=./factorio

@test "DEBUG=1 produces output" {
    source $factorio_script
    export DEBUG=1
    run debug "TEST"

    assert_output "DEBUG: TEST"
}

@test "DEBUG=0 produces no output" {
    source $factorio_script
    export DEBUG=0
    run debug "TEST"
    assert_output ""
}

#@test "load_config() " {}
#@test "usage()" {}
#@test "as_user()" {}
#@test "is_running()" {}
#@test "wait_pingpong()" {}
#@test "start_service()" {}
#@test "stop_service()" {}
#@test "send_cmd()" {}
#@test "cmd_players()" {}
#@test "check_permissions()" {}
#@test "test_deps()" {}
#@test "install()" {}
#@test "get_bin_version()" {}
#@test "get_bin_arch()" {}
#@test "update()" {}

#@test "run_main()" {}
    #start)
    #stop)
    #restart)
    #status)
    #cmd)
    #chatlog)
    #players)
    #players-online|online)
    #new-game)
    #save-game)
    #load-save)
    #install)
    #update)
    #inv|invocation)
    #help|--help|-h)
    #listcommands)
    #listsaves)
    #version)
