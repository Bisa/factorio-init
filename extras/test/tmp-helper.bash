create_tmp_dir() {
    suffix="${1-dir}"
    mktemp -d "${BATS_TMPDIR}/factorio-init-${suffix}.XXXXXX" || fail
}

create_tmp_empty_dir() {
    create_tmp_dir "empty" || fail
}

create_tmp_nonempty_dir() {
    dir=`create_tmp_dir "nonempty"`
    touch "${dir}/a_file" || fail
    echo "${dir}"
}

create_tmp_file() {
    suffix="${1-file}"
    mktemp "${BATS_TMPDIR}/factorio-init-${suffix}.XXXXXX" || fail
}

create_nonexisting_file() {
    mktemp -u || fail
}