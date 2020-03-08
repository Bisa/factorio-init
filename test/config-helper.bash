#!/bin/bash

check_config_defaults_command() {
    config_file="${BATS_TMPDIR}/readable"
    touch "${config_file}"
    
    source $factorio_script
    export DEBUG=1

    command=$1
    run load_config "${config_file}" ${command}
    assert_line "DEBUG: Skip check/loading defaults for command '${command}'"
}
