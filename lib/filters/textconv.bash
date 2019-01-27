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
    get_command_opts '' OPTKEY
    shift $(( OPTIND - 1 ))
    [[ "${1}" == '--' ]] && shift
    [[ -z "${1}" ]] && die 'missing command argument -- file'

    cat "${1}"
}
