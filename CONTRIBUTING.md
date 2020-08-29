# Contributors Guide

An overview of the repository layout, and how to build the project from source. Contribution to the project are always welcome. New ideas, bugs, and pull requests, all will be very much appreciated.

- [Build Requirements](#build-requirements)
- [Significant Locations](#significant-locations)
- [Building from source](#building-from-source)
- [Running tests](#running-tests)


## Build Requirements

  - `docker`

Alternatively, you could try to build the project locally. In that case you will need:

  - `crystal`
  - `git`
  - `gpg`
  - `make`


## Significant Locations

The following files and directories (relative to the root directory of an application), are of special significance:

  - `.profile` - this file will be sourced by the login shell on the container start up. Ideally, code in this file should be kept POSIX compliant.

  - `bin/docker` - a custom replacement for `docker-compose`. This script is used to build and run the project via docker. For more information see `bin/docker --help`.

  - `dockerfs` - represents root file system of the docker container. All files placed into this directory will be copied to the container preserving their mode and path.

  - `spec` - a directory where all the tests and tests related data is stored, including fixture files and gpg keys used for testing.


## Building from source

The application can be built either locally or with in docker development environment. With the exception of the first section, all commands described below apply to both: local builds and builds within the development environment.

- **Initialise development environment**

  ```
  ./bin/docker build
  ./bin/docker run
  ```

  The first of the commands above only needs to be run once. Also, this step can be skipped entirely if you're planning to build the project locally.

- **Create a development build**

  ```
  make tests
  make targets
  ```

  The first command runs a code style linter and a suite of behaviour tests. The second commands builds all targets defined in the `targets` section of your `shard.yml`.

  Both commands can be rolled into one by simply running:

  ```
  make
  ```

- **Create a new release**

  ```
  make release
  ```

  All executables listed in the `targets` section of your `shard.yml` will be available in `./bin` directory of the project.


## Running tests
