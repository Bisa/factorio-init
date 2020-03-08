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
    
    assert_line --index 0 "DEBUG: Trying to load config file './config'."
}

@test ".load_config sets default FACTORIO_PATH" {
    source $factorio_script
    unset FACTORIO_PATH
    load_config ./config.example
    assert_equal "${FACTORIO_PATH}" '/opt/factorio'
}

@test ".load_config does not override FACTORIO_PATH" {
    source $factorio_script
    config_file="${BATS_TMPDIR}/readable"
    touch "${config_file}"
    export FACTORIO_PATH="-my-predefined-path-"
    load_config "${config_file}"
    assert_equal "${FACTORIO_PATH}" '-my-predefined-path-'
}

@test ".load_config passes command to .config_defaults" {
    config_file="${BATS_TMPDIR}/readable"
    touch "${config_file}"
    
    source $factorio_script
    export DEBUG=1
    
    run load_config "${config_file}" install
    assert_line "DEBUG: Check/Loading config defaults for command 'install'"    
}

@test ".config_defualts skips 'install' command" {
    load 'config-helper'
    check_config_defaults_command "install"
}

@test ".config_defualts skips '' (empty) command" {
    load 'config-helper'
    check_config_defaults_command ""
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
