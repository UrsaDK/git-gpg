: ${GIT_TOPLEVEL_DIR:="$(git rev-parse --show-toplevel)"}
: ${GIT_TEST_DIR:="${GIT_TOPLEVEL_DIR}/test"}

: ${GIT_GPG_BIN:="${GIT_TOPLEVEL_DIR}/bin/git-gpg --no-color"}
: ${FIXTURES_DIR:="${GIT_TEST_DIR}/fixtures"}
: ${TMP_DIR:="${GIT_TEST_DIR}/tmp"}

FEATURE="$(basename "${BATS_TEST_FILENAME}" '.bats' | tr '_' ' ')"

setup() {
  mkdir -p "${TMP_DIR}"
}

teardown() {
  rm -Rf "${TMP_DIR}"
}

debug() {
    printf '\nEXPECTED:\n––––––––\n%s\n' "${1}" >&3
    printf '\nACTUAL:\n––––––––\n%s\n\n' "${2}" >&3
}

expect() {
  if ! test "${@}"; then
    case ${1} in
      -[[:alpha:]])
        debug "[[ ${1} ACTUAL ]]" "${!#}"
        ;;
      *)
        debug "${!#}" "${1}"
        ;;
    esac
    return 1
  fi
}
