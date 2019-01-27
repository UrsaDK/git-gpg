__help_keys() {
cat <<EOS
List all GPG recipients that can decode a file

    -s --staged             Work on the staged content
    -? --help               Display this help message

This command lists all GPG keys which can decode a file committed
to the repository. Encryption keys for a staged file can be shown
using -s option.

If the file is not encoded, then a warning is displayed and git-gpg
exits with an error.

    ${BASH_SOURCE##*/} ${FUNCNAME#__help_} -- <file>

EOS
}

__init_keys() {
    GIT_OBJECT='HEAD:'
    while get_command_opts 's stage' OPTKEY; do
        case ${OPTKEY} in
            's'|'staged')
                GIT_OBJECT=':'
                ;;
        esac
    done
    shift $(( OPTIND - 1 ))
    [[ "${1}" == '--' ]] && shift
    [[ -z "${1}" ]] && die 'missing command argument -- file'
    
    ${GIT_BIN} cat-file -p "${GIT_OBJECT}${1}" | content_keys \
        || die "file is not encrypted -- ${1}"
}

content_keys() {
    cat - \
        | ${GPG_BIN} --list-only --list-packets --quiet --batch --no-tty \
        | sed -n -E 's/^:pubkey enc packet: .* keyid (\w*)/\1/p'
}
