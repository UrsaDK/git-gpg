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
    get_command_opts '' OPTKEY
    shift $(( OPTIND - 1 ))
    [[ "${1}" == '--' ]] && shift
    [[ -z "${1}" ]] && die 'missing command argument -- path'

    if [[ -f .gitattributes ]]; then
        for file in ${@}; do
            sed -i '' -E "/^${file}[[:space:]]+filter=gpg[[:space:]]+diff=gpg$/d" .gitattributes
            echo "Untracking \"${file}\""
        done
    fi
}
