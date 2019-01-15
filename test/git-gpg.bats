#!/usr/bin/env bats

load test_helper

@test "${GIT_GPG_CMD} with no arguments fails" {
  run ${GIT_GPG_BIN}
  test "${status}" -gt 0
  test "${lines[0]}" == "git-gpg: missing command"
}

@test "${GIT_GPG_CMD} with an invalid option fails" {
  run ${GIT_GPG_BIN} -h
  test "${status}" -gt 0
  test "${lines[0]}" == "git-gpg: illegal option -- h"
}

@test "${GIT_GPG_CMD} with an invalid command fails" {
  run ${GIT_GPG_BIN} non-existent-command
  test "${status}" -gt 0
  test "${lines[0]}" == "git-gpg: illegal command -- non-existent-command"
}

@test "${GIT_GPG_CMD} -q –– fails with no output" {
  run ${GIT_GPG_BIN} -q
  test "${status}" -gt 0
  test -z "${output}"
}

@test "${GIT_GPG_CMD} --quiet –– fails with no output" {
  run ${GIT_GPG_BIN} --quiet
  test "${status}" -gt 0
  test -z "${output}"
}

@test "${GIT_GPG_CMD} --quiet version –– succeeds" {
  run ${GIT_GPG_BIN} --quiet version
  echo "# --> STATUS: =>${status}<="
  test "${status}" -eq 0
  test -z "${output}"
}

# @test "${GIT_GPG_CMD} -l --log
