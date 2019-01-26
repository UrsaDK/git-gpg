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
    while getopts "?-:" OPTKEY; do
        getopts_long OPTKEY
        case ${OPTKEY} in
            '?'|'help')
                __help_${COMMAND}
                exit
                ;;
            *)
                if [[ "$OPTERR" == 1 && "${optspec:0:1}" != ":" ]]; then
                    die "illegal smudge option -- ${OPTKEY}"
                fi
                ;;
        esac
    done
    shift $(( OPTIND - 1 ))
    [[ "${1}" == "--" ]] && shift

    : ${1:?Missing required parameter -- file}

    local content="$(base64 -)"

    if ! printf '%s' "${content}" | gpg_decrypt; then
        warn "Unencrypted content detected in the repository -- ${1}"
        printf '%s' "${content}" | base64 --decode -
    fi
}

gpg_decrypt() {
    base64 --decode - | ${GPG_BIN} --decrypt --quiet --batch --no-tty
}
