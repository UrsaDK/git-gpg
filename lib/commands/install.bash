__help_install() {
cat <<EOS
Install Git LFS configuration

    -? --help               Display this help message

Set up clean and smudge filters, and add diff textconv programme to Git
config. This will create a new configuration section called "gpg".
EOS
}

__init_install() {
    get_command_opts '' OPTKEY
    shift $(( OPTIND - 1 ))
    [[ "${1}" == '--' ]] && shift
    [[ -n "${1}" ]] && die "illegal command argument -- ${1}"

    git config --global --replace-all filter.gpg.required 'true'
    git config --global --replace-all filter.gpg.clean 'git-gpg clean -- %f'
    git config --global --replace-all filter.gpg.smudge 'git-gpg smudge -- %f'
    git config --global --replace-all filter.gpg.smudge 'git-gpg smudge -- %f'
    git config --global --replace-all diff.gpg.textconv 'git-gpg textconv'
}
