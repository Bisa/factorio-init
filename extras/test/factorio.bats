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

@test ".info produces output" {
    source $factorio_script
    run info "Informative text" # TODO: find a way to verify stdout vs stderr output

    assert_output 'Informative text'
}

@test ".load_config fails on missing config file" {
    source $factorio_script
    export DEBUG=0
    run load_config "nonexisting_config_file"
    
    assert_output "Config file 'nonexisting_config_file' does not exist!"
    assert_failure 1
}

@test ".load_config fails on non-readable config file" {
	[ $(id -u) -eq 0 ] && skip "We are running as root, we can not test non-readability"
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
    assert_line --index 19 'help'
    assert_success 1
}

@test ".install fails when FACTORIO_PATH is not empty" {
    load 'tmp-helper'
    load 'http-mock-helper'
    mock_curl_fail
    mock_wget_fail

    source $factorio_script
    load_config ./config.example
    FACTORIO_PATH="`create_tmp_nonempty_dir`"
    
    run install
    assert_output "Aborting install, '${FACTORIO_PATH}' is not empty!"
    assert_failure 1
}

@test ".install fails when FACTORIO_PATH is not writable" {
	[ $(id -u) -eq 0 ] && skip "We are running as root, we can not test non-writeability"
    load 'tmp-helper'
    load 'http-mock-helper'
    mock_curl_fail
    mock_wget_fail

    source $factorio_script
    load_config ./config.example
    FACTORIO_PATH="`create_tmp_empty_dir`"
    chmod a-w "${FACTORIO_PATH}"

    run install
    assert_output "Aborting install, unable to write to '${FACTORIO_PATH}'!"
    assert_failure 1
}

@test ".install fails on curl error" {
    load 'tmp-helper'
    load 'http-mock-helper'
    source $factorio_script

    mock_curl "${CURL_LATEST_STABLE_HEAD_CURLERR}" 1
    mock_wget_fail

    load_config ./config.example
    FACTORIO_PATH="`create_tmp_empty_dir`"
    DEBUG=1

    run install
    
    assert_output "\
DEBUG: Checking for latest headless version.
curl: (X) We ran into curl error X
Aborting install, unable to curl '${LATEST_HEADLESS_URL}'"
    assert_failure 1
}

@test ".install fails on non HTTP 200 status" {
    load 'tmp-helper'
    load 'http-mock-helper'
    source $factorio_script
    
    mock_curl "${CURL_LATEST_STABLE_HEAD_302_503}" 0
    mock_wget_fail
    
    load_config ./config.example
    FACTORIO_PATH="`create_tmp_empty_dir`"
    BINARY="${FACTORIO_PATH}/bin/x64/factorio"
    INSTALL_CACHE_TAR=1
    USERNAME=`whoami`
    USERGROUP=`whoami`
    DEBUG=1

    run install
    
    assert_line "Aborting install, expected HTTP 200 from '${LATEST_HEADLESS_URL}', got '503'."
    assert_failure 1
}

@test ".install fails when tarball is missing" {
    load 'tmp-helper'
    load 'http-mock-helper'
    mock_curl_fail
    mock_wget_fail
    
    source $factorio_script
    load_config ./config.example
    FACTORIO_PATH="`create_tmp_empty_dir`"
    
    nofile="`create_nonexisting_file tarball`"
    run install "${nofile}"
    assert_output "Aborting install, '"${nofile}"' does not exist!"
    assert_failure 1
}

@test ".install uses cached tarball" {
    [ -z "${FACTORIO_INIT_WITH_TEST_RESOURCES}" ] && skip "We are not running tests with resources"

    load 'tmp-helper'
    load 'http-mock-helper'
    source $factorio_script
    
    mock_curl "${CURL_LATEST_STABLE_HEAD_302_200}" 0
    mock_wget_fail
    
    config_file="${BATS_TMPDIR}/config"
	cp ./config.example "${config_file}"
	if [ -n "${FACTORIO_INIT_ALT_GLIBC}" ]; then
		sed -i -e 's/ALT_GLIBC=0/ALT_GLIBC=1/' "${config_file}"
	fi
	sed -i -e 's#FACTORIO_PATH=/opt/factorio#FACTORIO_PATH="`create_tmp_empty_dir`"#' "${config_file}"
	load_config "${config_file}"

    INSTALL_CACHE_TAR=1
    USERNAME=`whoami`
    USERGROUP=`whoami`
    DEBUG=1

    run install
    
    assert_line "Installation complete, edit '${FACTORIO_PATH}/data/server-settings.json' and start your server."
    assert_success
}

@test ".install uses provided tarball" {
    [ -z "${FACTORIO_INIT_WITH_TEST_RESOURCES}" ] && skip "We are not running tests with resources"
    load 'tmp-helper'
    load 'http-mock-helper'
    source $factorio_script

    mock_curl_fail
    mock_wget_fail
    
    config_file="${BATS_TMPDIR}/config"
	cp ./config.example "${config_file}"
	if [ -n "${FACTORIO_INIT_ALT_GLIBC}" ]; then
		sed -i -e 's/ALT_GLIBC=0/ALT_GLIBC=1/' "${config_file}"
	fi
	sed -i -e 's#FACTORIO_PATH=/opt/factorio#FACTORIO_PATH="`create_tmp_empty_dir`"#' "${config_file}"
	load_config "${config_file}"
    
	DEBUG=1
    tarball="/tmp/factorio_headless_x64_1.1.61.tar.xz"

    run install "${tarball}"
    
    refute_line "DEBUG: Found cached '${tarball}'."
    refute_line "DEBUG: No cache hit for '${filename}'."
    assert_line "Installation complete, edit '${FACTORIO_PATH}/data/server-settings.json' and start your server."
    assert_success
}

#
#grep -P '(function [^\(]+\(.+)|^ +[^\(\)]+\)$' factorio
#
#function debug() {
#function error() {
#function info() {
#function load_config() {
#function config_defaults() {
#    install|help|listcommands|version|"")
#    *)
#function usage() {
#function as_user() {
#function is_running() {
#function wait_pingpong() {
#function start_service() {
#function stop_service() {
#function send_cmd(){
#function cmd_players(){
#function check_permissions(){
#function test_deps(){
#function install(){
#function get_bin_version(){
#function get_bin_arch(){
#function update(){
#function mod() {
#  function mod_usage() {
#    update)
#    install)
#    enable)
#    disable)
#    remove)
#    list)
#    help)
#    *)
#function run_main(){
#    help|listcommands)
#    *)
#    start)
#    stop)
#    restart)
#    status)
#    cmd)
#    log)
#        --tail|-t)
#        *)
#    chatlog)
#        --tail|-t)
#        *)
#    players)
#    players-online|online)
#    new-game)
#    save-game)
#    load-save)
#    install)
#    update)
#    inv|invocation)
#    help)
#    listcommands)
#    listsaves)
#    version)
#    mod)
#    *)
