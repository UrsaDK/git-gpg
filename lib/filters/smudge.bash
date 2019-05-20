__help_smudge() {
cat <<EOS
Git smudge filter used to decrypt file content

    -? --help               Display this help message

This filter accepts a single additional parameter, which defines
the path to the file the filter is working on.

    ${BASH_SOURCE##*/} ${FUNCNAME#__help_} -- <file>

EOS
}

__init_smudge() {
    get_command_opts '' OPTKEY
    shift $(( OPTIND - 1 ))
    [[ "${1}" == '--' ]] && shift
    [[ -z "${1}" ]] && die 'missing command argument -- file'

    local content
    content="$(base64 -)"

    if ! printf '%s' "${content}" | gpg_decrypt; then
        warn "file is not encrypted -- ${1}"
        printf '%s' "${content}" | base64 --decode -
    fi
}

gpg_decrypt() {
    base64 --decode - | ${GPG_BIN} --decrypt --quiet --batch --no-tty
}
