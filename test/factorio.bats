#!/usr/bin/env ./test/libs/bats/bin/bats
load 'libs/bats-support/load'
load 'libs/bats-assert/load'

factorio_script=./factorio

@test ".debug DEBUG=1 produces output" {
    source $factorio_script
    export DEBUG=1
    run debug "TEST" # TODO: find a way to verify stdout vs stderr output

    assert_output "DEBUG: TEST"
}

@test ".debug DEBUG=0 produces no output" {
    source $factorio_script
    export DEBUG=0
    run debug "TEST"

    assert_output ""
}

@test ".debug is turned off by default" {
    source $factorio_script
    run debug "TEST"

    assert_output ""
}

@test ".error produces output" {
    source $factorio_script
    run error "An error occured!" # TODO: find a way to verify stdout vs stderr output

    assert_output 'An error occured!'
}

@test ".load_config fails on missing config file" {
    source $factorio_script
    export DEBUG=0
    run load_config "nonexisting_config_file"
    
    assert_output "Config file 'nonexisting_config_file' does not exist!"
    assert_failure 1
}

@test ".load_config fails on non-readable config file" {
    config_file="${BATS_TMPDIR}/non-readable"
    touch "${config_file}"
    chmod a-r "${config_file}"

    source $factorio_script
    export DEBUG=0
    run load_config "${config_file}"
    
    assert_output "Unable to read config file '"${config_file}"'!"
    assert_failure 1
}

@test ".load_config without args uses default file" {
    source $factorio_script
    export DEBUG=1
    run load_config
    
    assert_output "DEBUG: Trying to load config file './config'."
}

#@test "config_defaults() {}"
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
