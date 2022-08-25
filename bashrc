#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return
export HISTFILE="${XDG_STATE_HOME}"/bash/history
GREEN="\[$(tput setaf 2)\]"
RESET="\[$(tput sgr0)\]"
GREEN="$(tput setaf 2)"
RESET="$(tput sgr0)"


alias ls='ls --color=auto'
#PS1='[\u@\h \W]\$ '
PS1='${GREEN}\u \W > ${RESET}'

# source shprofile
source ~/.config/shprofile

source /usr/share/bash-completion/bash_completion

# BEGIN_KITTY_SHELL_INTEGRATION
if test -n "$KITTY_INSTALLATION_DIR" -a -e "$KITTY_INSTALLATION_DIR/shell-integration/bash/kitty.bash"; then source "$KITTY_INSTALLATION_DIR/shell-integration/bash/kitty.bash"; fi
# END_KITTY_SHELL_INTEGRATION
