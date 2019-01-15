: ${GIT_TOPLEVEL_DIR:="$(git rev-parse --show-toplevel)"}
: ${GIT_TEST_DIR:="${GIT_TOPLEVEL_DIR}/test"}

: ${GIT_GPG_BIN:="${GIT_TOPLEVEL_DIR}/bin/git-gpg"}
: ${GIT_GPG_CMD:="${GIT_GPG_BIN##*/}"}

: ${FIXTURES_DIR:="${GIT_TEST_DIR}/fixtures"}
: ${TMP_DIR:="${GIT_TEST_DIR}/tmp"}

setup() {
  mkdir -p "${TMP_DIR}"
}

teardown() {
  rm -Rf "${TMP_DIR}"
}
