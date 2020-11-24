#!/usr/bin/env ./test/libs/bats/bin/bats
load 'libs/bats-support/load'
load 'libs/bats-assert/load'

factorio_script=./factorio

@test ".run_main new-game SAVENAME MAP_GEN_SETTINGS MAP_SETTINGS creates a new game" {
    [ -z "${FACTORIO_INIT_WITH_PRE_INSTALLED_GAME}" ] && skip "We are not running tests with pre-installed game"
    source $factorio_script
    config_file="${BATS_TMPDIR}/config"

	cp ./config.example "${config_file}"
	sed -i -e 's/DEBUG=0/DEBUG=1/' "${config_file}"
	if [ -n "${FACTORIO_INIT_ALT_GLIBC}" ]; then
		sed -i -e 's/ALT_GLIBC=0/ALT_GLIBC=1/' "${config_file}"
	fi

	factorio_path="/opt/factorio"
    save_name="new-game-test"
	map_gen="map-gen-settings.example.json"
	map_settings="map-settings.example.json"
    # TODO: make pre-installed game tests run in parallel
    run run_main "${config_file}" new-game "${save_name}" "${map_gen}" "${map_settings}"
    
	assert_output --partial "Program arguments: \"${factorio_path}/bin/x64/factorio\" \"--create\" \"${factorio_path}/bin/x64/../../saves/${save_name}\" \"--map-gen-settings=${factorio_path}/bin/x64/../../data/${map_gen}\""
	assert_line "New game created: ${factorio_path}/bin/x64/../../saves/${save_name}.zip"
    assert_success 
}

@test ".run_main new-game SAVENAME MAP_GEN_SETTINGS creates a new game" {
    [ -z "${FACTORIO_INIT_WITH_PRE_INSTALLED_GAME}" ] && skip "We are not running tests with pre-installed game"
    source $factorio_script
    config_file="${BATS_TMPDIR}/config"

	cp ./config.example "${config_file}"
	sed -i -e 's/DEBUG=0/DEBUG=1/' "${config_file}"
	if [ -n "${FACTORIO_INIT_ALT_GLIBC}" ]; then
		sed -i -e 's/ALT_GLIBC=0/ALT_GLIBC=1/' "${config_file}"
	fi

	factorio_path="/opt/factorio"
    save_name="new-game-test"
	map_gen="map-gen-settings.example.json"
    # TODO: make pre-installed game tests run in parallel
    run run_main "${config_file}" new-game "${save_name}" "${map_gen}"
    
	assert_output --partial "Program arguments: \"${factorio_path}/bin/x64/factorio\" \"--create\" \"${factorio_path}/bin/x64/../../saves/${save_name}\" \"--map-gen-settings=${factorio_path}/bin/x64/../../data/${map_gen}\""
	assert_line "New game created: ${factorio_path}/bin/x64/../../saves/${save_name}.zip"
    assert_success 
}

@test ".run_main new-game SAVENAME creates a new game" {
    [ -z "${FACTORIO_INIT_WITH_PRE_INSTALLED_GAME}" ] && skip "We are not running tests with pre-installed game"
    source $factorio_script
    config_file="${BATS_TMPDIR}/config"

	cp ./config.example "${config_file}"
	sed -i -e 's/DEBUG=0/DEBUG=1/' "${config_file}"
	if [ -n "${FACTORIO_INIT_ALT_GLIBC}" ]; then
		sed -i -e 's/ALT_GLIBC=0/ALT_GLIBC=1/' "${config_file}"
	fi

	factorio_path="/opt/factorio"
    save_name="new-game-test"
    # TODO: make pre-installed game tests run in parallel
    run run_main "${config_file}" new-game "${save_name}"
    
	assert_output --partial "Program arguments: \"${factorio_path}/bin/x64/factorio\" \"--create\" \"${factorio_path}/bin/x64/../../saves/${save_name}\""
	assert_line "New game created: ${factorio_path}/bin/x64/../../saves/${save_name}.zip"
    assert_success 
}

