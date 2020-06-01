# This file is here to provide a bridge to the project specific `.profile`.
# Any code you want to add here should instead be added to `/mnt/.profile`
#
# When the application container is built this file will be overridden by
# the project specific `.profile`. All changes made here WILL BE LOST!
#
[[ -s "/mnt/.profile" ]] && . "/mnt/.profile"
