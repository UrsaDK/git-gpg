__help_track() {
cat <<EOS
Add paths to Git attributes file

    --no-excluded           Do not list excluded patterns
    -? --help               Display this help message

Start tracking the given path(s) with Git GPG. All files matching
the <path> are added to .gitattributes. They will be encoded the
next time they are committed to the repository.

Content which is already committed to the repository, will remain
as it is and will not be altered.

The <path> argument can be a glob pattern or a file path.

    ${BASH_SOURCE##*/} ${FUNCNAME#__help_} -- [path]

If no paths are provided, simply list the currently-tracked paths.
EOS
}

__init_track() {
    while getopts "?-:" OPTKEY; do
        getopts_long OPTKEY
        case ${OPTKEY} in
            'no-excluded')
                SKIP_EXCLUDED=1
                ;;
            '?'|'help')
                __help_${COMMAND}
                exit
                ;;
            *)
                if [[ "$OPTERR" == 1 && "${optspec:0:1}" != ":" ]]; then
                    die "illegal track option -- ${OPTKEY}"
                fi
                ;;
        esac
    done
    shift $(( OPTIND - 1 ))
    [[ "${1}" == "--" ]] && shift

    if [[ -n "${@}" ]]; then
        for file in ${@}; do
            echo "${file} filter=gpg diff=gpg" >> .gitattributes
            echo "Tracking \"${file}\""
        done
    else
        echo "Listing tracked patterns"
        for git_attr in $(find . -name .gitattributes); do
            gitattr_grep 's/^(.*)[[:space:]]+filter=gpg[[:space:]]+diff=gpg$/\1/p' "${git_attr}"
        done

        if [[ -z "${SKIP_EXCLUDED}" ]]; then
            echo "Listing excluded patterns"
            for git_attr in $(find . -name .gitattributes); do
                gitattr_grep 's/^(.*)[[:space:]]+-filter(=gpg)?([[:space:]]+.*)?$/\1/p' "${git_attr}"
            done
        fi
    fi
}

gitattr_grep() {
    : ${1:?Missing required argument -- regex}
    : ${2:?Missing required argument -- path}
    dir_prefix="${2%.gitattributes}"
    for file in $(sed -n -E "${1}" "${git_attr}"); do
        echo "    ${dir_prefix#./}${file} (${2#./})"
    done
}
