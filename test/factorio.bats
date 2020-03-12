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

@test ".config_defualts skips '' (empty) command" {
    load 'config-helper'
    check_config_defaults_skip_command ""
}

@test ".config_defualts skips 'install' command" {
    load 'config-helper'
    check_config_defaults_skip_command "install"
}

@test ".config_defualts skips 'help' command" {
    load 'config-helper'
    check_config_defaults_skip_command "help"
}

@test ".config_defualts skips 'listcommands' command" {
    load 'config-helper'
    check_config_defaults_skip_command "listcommands"
}

@test ".config_defualts skips 'version' command" {
    load 'config-helper'
    check_config_defaults_skip_command "version"
}

@test ".run_main 'help' works without config" {
    source $factorio_script
    run run_main "" help
    
    assert_line --regexp '^Usage: .+ COMMAND$'
    assert_line --index 1 'Available commands:'
    assert_success 1
}

@test ".run_main 'listcommands' works without config" {
    source $factorio_script
    run run_main "" listcommands
    
    assert_line --index 0 'start'
    assert_line --index 17 'help'
    assert_success 1
}

@test ".install fails when FACTORIO_PATH is not empty" {
    load 'tmp-helper'

    source $factorio_script
    load_config ./config.example
    FACTORIO_PATH="`create_tmp_nonempty_dir`"
    
    run install
    assert_output "Aborting install, '${FACTORIO_PATH}' is not empty!"
    assert_failure 1
}

@test ".install fails when tarball is missing" {
    load 'tmp-helper'
    
    source $factorio_script
    load_config ./config.example
    
    nofile="`create_nonexisting_file tarball`"
    run install "${nofile}"
    assert_output "Aborting install, '"${nofile}"' does not exist!"
    assert_failure 1
}

@test ".install fails when FACTORIO_PATH is not writable" {
    load 'tmp-helper'

    source $factorio_script
    load_config ./config.example
    FACTORIO_PATH="`create_tmp_empty_dir`"
    chmod a-w "${FACTORIO_PATH}"

    run install
    assert_output "Aborting install, unable to write to '${FACTORIO_PATH}'!"
    assert_failure 1
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
