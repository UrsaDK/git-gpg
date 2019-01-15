<img src="https://umka.dk/git-gpg/logo.png" alt="git-gpg" align="left" height="70">

**Version:** 1.0.0 <br>
**Status:** Fully functional, missing tests

<br>

# Git-GPG

This Git extension allows an individual user or a team of authorised users to protect sensitive information in the repository using GPG. Protected files are  automatically encrypted before being committed to the repository. They are also automatically decrypted when the repository is checked out by one of the authorised users. Once setup, the extension works completely transparently and requires no further input from the user.

Git-GPG is tightly integrated with the existing git sub-systems, and provides the following features:

- command line support for enabling and disabling encrypted storage of any file;

- global, as well as per file, list of GPG keys with which the files are encrypted;

- GPG keys which are used to encrypt a file are defined via git-config;

- full support for git diff, including diffs between branches and previous commits;

- command line interface is kept consistent with git-lfs;

The use of GPG for file encryption has a number of distinct advantages over a more traditional method of using symmetric key algorithms, such as OpenSSL:

First and foremost, using GPG encryption simplifies removing existing authorised users and prevents exposing historical data to new authorised users. This means that given four sequential commits (A-B-C-D), where commits A & C are encrypted for user X, and commits B & D are encrypted for users X & Y, the user Y will only be able to decrypt data committed as part of commits B & D. Data committed in A & C will remain inaccessible to that user.

This behaviour is the result of Git-GPG re-encrypting protected files with the latest list of authorised public keys every time a file is changed. To achieve similar functionality using a symmetric key, every time an authorised user is added or removed the repository owner would have to reset the symmetric key, re-encode all encrypted files, and re-distribute the new key to all authorised users. None of this is necessary when using Git-GPG.

Another big advantage of using GPG is that git is already aware of GPG and uses user's GPG public key to sign and verify user commits. This means that, if the user's GPG key is configured to support not only Sign and Confirm operations but also Encrypt, then any file in the repository can be encrypted for any user that has made a verified commit to that repository.


## Installation

## Usage

## Configuration

## Alternatives

There is a number of similar
