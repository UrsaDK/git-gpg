#!/usr/bin/env bats

load test_helper

@test "${GIT_GPG_CMD} --version –– succeeds and matches script version" {
  eval "$(sed '3q;d' ${GIT_GPG_BIN})"
  run ${GIT_GPG_BIN} --version
  test "${status}" -eq 0
  test "${output}" == "git-gpg/${VERSION}"
}

@test "${GIT_GPG_CMD} version –– succeeds and matches script version" {
  eval "$(sed '3q;d' ${GIT_GPG_BIN})"
  run ${GIT_GPG_BIN} version
  test "${status}" -eq 0
  test "${output}" == "git-gpg/${VERSION}"
}

@test "${GIT_GPG_CMD} version –– succeeds and matches README version" {
  readme_version="$(sed '3q;d' "${GIT_TOPLEVEL_DIR}/README.md")"
  run ${GIT_GPG_BIN} version
  test "${status}" -eq 0
  test "${readme_version}" == "**Version:** ${output} <br>"
}
