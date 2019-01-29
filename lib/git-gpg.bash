__help() {
cat <<EOS
Usage: ${BASH_SOURCE##*/} [options] <commands>

Options                 <> - required parameters
-------                 [] - optional parameters

-c --color              Enable color in errors and warnings
-n --no-color           Disable color in errors and warnings
-l --log=<path>         Redirect all output to a file
-q --quiet              Suppress output of the script
--help                  Display this help message
--version               Script and BASH version info

Commands                <> - required parameters
--------                [] - optional parameters

install                 $(__help_install | head -1)
keys <file>             $(__help_keys | head -1)
track [path]            $(__help_track | head -1)
untrack <path>          $(__help_untrack | head -1)
version                 Show ${BASH_SOURCE##*/} version number
help [command]          Display help for the command

Filters                 <> - required parameters
-------                 [] - optional parameters

clean <file>            $(__help_clean | head -1)
smudge <file>           $(__help_smudge | head -1)
textconv                $(__help_textconv | head -1)

EOS
}

__init() {
    # [Constructor] Initialise script's sub-command
    type -t "__init_${COMMAND}" >/dev/null && __init_${COMMAND}
}

__exit() {
    # [Destructor] Executed when the script exits
    type -t "__exit_${COMMAND}" >/dev/null && __exit_${COMMAND}
}

warn() {
    : ${1?Missing required parameter -- error message}
    if ${GIT_GPG_COLOR}; then
        printf "\e[33mWARNING: %s\e[0m\n" "${1}" >&2
    else
        echo "WARNING: ${1}" >&2
    fi
}

die() {
    : ${1?Missing required parameter -- error message}
    if ${GIT_GPG_COLOR}; then
        printf "\e[31m%s: %s\e[0m\n" "${BASH_SOURCE##*/}" "${1}" >&2
    else
        echo "${BASH_SOURCE##*/}: ${1}" >&2
    fi
    exit ${2:-1}
}

version() {
    echo "${BASH_SOURCE##*/}/${VERSION}"
}

set_var() {
    : ${1:?Missing required parameter -- variable name}
    : ${3:?Missing required parameter -- error message}
    printf -v ${1} "${!1:-${2}}"
    [[ -z "${!1}"} ]] && die "${3}"
}

should_git_use_color() {
    local is_tty="$(tty -s && echo 'true' || echo 'false')"
    echo "$(${GIT_BIN} config --get-colorbool color.gpg ${is_tty})"
}

get_command_opts() {
    getopts_long ":${1} help" ${2} ${@:3} || return 1
    case ${!2} in
      'help')
          __help_${COMMAND}
          exit
          ;;
      '?')
          die "illegal command option -- ${OPTARG}"
          ;;
      ':')
          die "command option requires an argument -- ${OPTARG}"
          ;;
      *)
          die "unimplemented command option -- ${OPTKEY}"
          ;;
    esac
}
