__help_clean() {
cat <<EOS
Git clean filter used to encrypt file content

    -? --help               Display this help message

This filter accepts a single additional parameter, which defines
the path to the file the filter is working on.

    ${BASH_SOURCE##*/} ${FUNCNAME#__help_} -- <file>

EOS
}

__init_clean() {
    while getopts "?-:" OPTKEY; do
        getopts_long OPTKEY
        case ${OPTKEY} in
            '?'|'help')
                __help_${COMMAND}
                exit
                ;;
            *)
                if [[ "$OPTERR" == 1 && "${optspec:0:1}" != ":" ]]; then
                    die "illegal clean option -- ${OPTKEY}"
                fi
                ;;
        esac
    done
    shift $(( OPTIND - 1 ))
    [[ "${1}" == "--" ]] && shift

    : ${1:?Missing required parameter -- file}

    local actual_content="$(base64 -)"
    local actual_content_hash="${actual_content:+$(printf '%s' "${actual_content}" \
        | base64 --decode - \
        | ${GPG_BIN} --print-md sha256)}"

    local git_content="$(${GIT_BIN} cat-file -p "HEAD:${1}" 2>/dev/null | base64 -)"
    local git_content_hash="${git_content:+$(printf '%s' "${git_content}" \
        | gpg_decrypt \
        | ${GPG_BIN} --print-md sha256)}"

    if [[ -n "${git_content}" && "${git_content_hash}" == "${actual_content_hash}" ]]; then
        printf '%s' "${git_content}" | base64 --decode -
    else
        printf '%s' "${actual_content}" | gpg_encrypt "${1}"
    fi
}

gpg_encrypt() {
    : ${1:?Missing required parameter -- file}
    local gpg_recipients
    for recipient in $(gpg_recipients_for "${1}"); do
        gpg_recipients+=" --recipient ${recipient}"
    done

    base64 --decode - \
        | ${GPG_BIN} --encrypt --quiet --batch --no-tty ${gpg_recipients}
}

gpg_recipients() {
    : ${1:?Missing required parameter -- file}
    local gpg_keys="$(${GIT_BIN} config gpg.keys)"
    if [[ -z "${gpg_keys}" ]]; then
        ${GIT_BIN} config user.email
    elif [[ "${gpg_keys:0:1}" == '!' ]]; then
        ( ${gpg_keys:1} ) | parse_keysfile "${1}"
    elif [[ -f "${GIT_TOPLEVEL_DIR}/${gpg_keys}" ]]; then
        cat "${gpg_keys}" | parse_keysfile "${1}"
    else
        echo "${gpg_keys}"
    fi
}

parse_keysfile() (
    : ${1:?Missing required parameter -- file}
    shopt -s extglob
    while read -r pattern recipients; do
        if [[ "${1}" == ${pattern} ]]; then
            gpg_keys="${recipients}"
        fi
    done < <(cat - | sed -e '/^[[:space:]]*$/d' -e '/^[[:space:]]*#/d')
    echo "${gpg_keys}"
)
