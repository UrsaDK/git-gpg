# DO *NOT* EDIT THIS FILE
#
# Bash on Alpine is compiled without support for a system-wide startup file
# for interactive non-login shells. To simulate system-wide configurations
# settings are loaded via individual users .bashrc files.
#
[[ -s "${ENV}" ]] && source "${ENV}"
