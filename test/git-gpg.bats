#!/usr/bin/env bats

load test_helper

@test "${FEATURE}: with no arguments" {
  run ${GIT_GPG_BIN}
  expect "${status}" -ge 1
  expect "${lines[0]}" == "git-gpg: missing required command"
}

@test "${FEATURE}: with invalid short option" {
  run ${GIT_GPG_BIN} -z
  expect "${status}" -ge 1
  expect "${lines[0]}" == "git-gpg: illegal option -- z"
}

@test "${FEATURE}: with invalid long option" {
  run ${GIT_GPG_BIN} --zero
  expect "${status}" -ge 1
  expect "${lines[0]}" == "git-gpg: illegal option -- zero"
}

@test "${FEATURE}: with an invalid command" {
  run ${GIT_GPG_BIN} zero
  expect "${status}" -ge 1
  expect "${lines[0]}" == "git-gpg: illegal command -- zero"
}

@test "${FEATURE}: with -q shows no output" {
  run ${GIT_GPG_BIN} -q
  expect "${status}" -ge 1
  expect -z "${output}"
}

@test "${FEATURE}: with --quiet shows no output" {
  run ${GIT_GPG_BIN} --quiet
  expect "${status}" -ge 1
  expect -z "${output}"
}

@test "${FEATURE}: with -l but without specifying a logfile" {
  run ${GIT_GPG_BIN} -l
  expect "${status}" -ge 1
  expect "${output}" == 'git-gpg: option requires an argument -- l'
}

@test "${FEATURE}: with --log but without specifying a logfile" {
  run ${GIT_GPG_BIN} --log
  expect "${status}" -ge 1
  expect "${output}" == 'git-gpg: option requires an argument -- log'
}

@test "${FEATURE}: with --log and a log file" {
  local log_file="${TMP_DIR}/output.log"
  run ${GIT_GPG_BIN} -l "${log_file}"
  expect "${status}" -ge 1
  expect -f "${log_file}"
  expect "$(cat ${log_file})" == "git-gpg: missing required command"
}
