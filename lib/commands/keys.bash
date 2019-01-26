__help_keys() {
cat <<EOS
List all GPG keys which can decode a file

    -s --staged             Work on the staged content
    -? --help               Display this help message

GPG can encode a file for multiple recipients using their public keys,
see GPG's --recipient option for more details. This command will list
all public keys used in the encoding of the committed file.

    ${BASH_SOURCE##*/} ${FUNCNAME#__help_} -- <file>

EOS
}

__init_keys() {
    while getopts "?-:" OPTKEY; do
        getopts_long OPTKEY
        case ${OPTKEY} in
            's'|'staged')
                GIT_OBJECT=":"
                ;;
            '?'|'help')
                __help_${COMMAND}
                exit
                ;;
            *)
                if [[ "$OPTERR" == 1 && "${optspec:0:1}" != ":" ]]; then
                    die "illegal keys option -- ${OPTKEY}"
                fi
                ;;
        esac
    done
    shift $(( OPTIND - 1 ))
    [[ "${1}" == "--" ]] && shift

    : ${1:?Missing required parameter -- file}
    : ${GIT_OBJECT:="HEAD:"}

    ${GIT_BIN} cat-file -p "${GIT_OBJECT}${1}" | content_keys
}

content_keys() {
    cat - \
        | ${GPG_BIN} --list-only --list-packets --quiet --batch --no-tty \
        | sed -n -E 's/^:pubkey enc packet: .* keyid (\w*)/\1/p'
}
