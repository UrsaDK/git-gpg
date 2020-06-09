# Standard library API

This directory contains changes introduced into Crystal standard library. Most of these were either done to fix existing bugs or to upgrade tagged standard library to features introduced in the master branch.

## OptionParser subcommands

Subcommands are not available in `OptionParser` which is included in Crystal's standard library version 0.34.0. However, support for them is present in the `master` branch, though the branch contains breaking changes (eg: #[9134](https://github.com/crystal-lang/crystal/pull/9134)).

Instead of reinventing the wheel and writing my own implementation of the parser, I've decided to backport `OptionParser` from the master branch. In the process of doing so I've also resolved all of the following issues:

  - allowed `OptionParser` functionality to be customised by extending the class
