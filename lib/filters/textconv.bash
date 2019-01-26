__help_textconv() {
cat <<EOS
Git textconv filter used to diff encrypted files

    -? --help               Display this help message

This filter accepts a single additional parameter, which defines
the path to the file the filter is working on.

    ${BASH_SOURCE##*/} ${FUNCNAME#__help_} -- <file>

EOS
}

__init_textconv() {
    while getopts "?-:" OPTKEY; do
        getopts_long OPTKEY
        case ${OPTKEY} in
            '?'|'help')
                __help_${COMMAND}
                exit
                ;;
            *)
                if [[ "$OPTERR" == 1 && "${optspec:0:1}" != ":" ]]; then
                    die "illegal textconv option -- ${OPTKEY}"
                fi
                ;;
        esac
    done
    shift $(( OPTIND - 1 ))
    [[ "${1}" == "--" ]] && shift

    : ${1:?Missing required parameter -- filepath}

    cat "${1}"
}
