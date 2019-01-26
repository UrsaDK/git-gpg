__help_untrack() {
cat <<EOS
Remove paths from Git attributes

    -? --help               Display this help message

Stop tracking the given path(s) through Git GPG. All files matching
the <path> are removed from .gitattributes. The next time they are
committed to the repository, they will be stored as they are.

Content which is already committed to the repository, will remain
as it is and will not be altered.

The <path> argument can be a glob pattern or a file path.

    ${BASH_SOURCE##*/} ${FUNCNAME#__help_} -- <path>

EOS
}

__init_untrack() {
    while getopts "?-:" OPTKEY; do
        getopts_long OPTKEY
        case ${OPTKEY} in
            '?'|'help')
                __help_${COMMAND}
                exit
                ;;
            *)
                if [[ "$OPTERR" == 1 && "${optspec:0:1}" != ":" ]]; then
                    die "illegal untrack option -- ${OPTKEY}"
                fi
                ;;
        esac
    done
    shift $(( OPTIND - 1 ))
    [[ "${1}" == "--" ]] && shift

    : ${1:?Missing required parameter -- path}

    if [[ -f .gitattributes ]]; then
        for file in ${@}; do
            sed -i '' -E "/^${file}[[:space:]]+filter=gpg[[:space:]]+diff=gpg$/d" .gitattributes
            echo "Untracking \"${file}\""
        done
    fi
}
