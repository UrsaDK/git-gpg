# Contributors Guide

An overview of the repository layout, and how to build the project from source. Contribution to the project are always welcome. New ideas, bugs, and pull requests, all will be very much appreciated.

## Build Requirements

  - `crystal`
  - `docker`
  - `git`

## Significant Locations

The following files and directories (relative to the root directory of an application), are of special significance:

  - `.profile` - this file will be sourced by the login shell on the container start up. Ideally, code in this file should be kept POSIX compliant.

  - `bin/docker` - a custom replacement for `docker-compose`. This script is used to build and run the project via docker. For more information see `bin/docker --help`.

  - `dockerfs` - represents root file system of the docker container. All files placed into this directory will be copied to the container preserving their mode and path.
