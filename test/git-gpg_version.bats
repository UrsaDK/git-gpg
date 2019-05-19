#!/usr/bin/env bats

load test_helper

@test "${FEATURE}: with no options" {
  run ${GIT_GPG_BIN} version
  expect "${status}" -eq 0
  expect "${output}" == "$(cat ${GIT_TOPLEVEL_DIR}/VERSION)"
}

# @test "${FEATURE}: with --quiet shows no output" {
#   run ${GIT_GPG_BIN} version
#   expect "${status}" -ge 1
#   expect "${lines[0]}" == "git-gpg: missing required command"
# }
#
#
# @test "${GIT_GPG_CMD} --version –– succeeds and matches script version" {
#   eval "$(sed '3q;d' ${GIT_GPG_BIN})"
#   run ${GIT_GPG_BIN} --version
#   test "${status}" -eq 0
#   test "${output}" == "git-gpg/${VERSION}"
# }
#
# @test "${GIT_GPG_CMD} version –– succeeds and matches script version" {
#   eval "$(sed '3q;d' ${GIT_GPG_BIN})"
#   run ${GIT_GPG_BIN} version
#   test "${status}" -eq 0
#   test "${output}" == "git-gpg/${VERSION}"
# }
#
# @test "${GIT_GPG_CMD} version –– succeeds and matches README version" {
#   readme_version="$(sed '3q;d' "${GIT_TOPLEVEL_DIR}/README.md")"
#   run ${GIT_GPG_BIN} version
#   test "${status}" -eq 0
#   test "${readme_version}" == "**Version:** ${output} <br>"
# }
