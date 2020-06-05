<div align="center">

  [![git-gpg logo](https://raw.githubusercontent.com/UrsaDK/git-gpg/master/docs/images/logo.png)](#)<br>

  [![stable branch](https://img.shields.io/badge/dynamic/json.svg?logo=github&color=lightgrey&label=stable&query=%24.default_branch&url=https%3A%2F%2Fapi.github.com%2Frepos%2FUrsaDK%2Fgit-gpg)](https://github.com/UrsaDK/git-gpg)
  [![latest release](https://img.shields.io/badge/dynamic/json.svg?logo=docker&color=blue&label=release&query=%24.name&url=https%3A%2F%2Fapi.github.com%2Frepos%2FUrsaDK%2Fgit-gpg%2Freleases%2Flatest)](https://hub.docker.com/r/ursadk/git-gpg)
  [![test coverage](https://codecov.io/gh/UrsaDK/git-gpg/graph/badge.svg)](https://codecov.io/gh/UrsaDK/git-gpg)
  [![donate link](https://img.shields.io/badge/donate-coinbase-gold.svg?colorB=ff8e00&logo=bitcoin)](https://commerce.coinbase.com/checkout/0de16e60-3c37-4f5a-ab85-7a2708b40d68)

</div>

# Git-GPG

Git extension that allows secure storage of sensitive information within a repository. This is achieved by transparently encrypting / decrypting files with GPG: the files are stored encrypted within the repository, but authorised users see decrypted content when the files are checked out locally. The tool works in a completely transparent manner and requires neither input from the user, nor changes to the user workflow.

- [Requirements](#requirements)


## Requirements

  - `git`
