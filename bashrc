#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return
export HISTFILE="${XDG_STATE_HOME}"/bash/history
# GREEN="\[$(tput setaf 2)\]"
# RESET="\[$(tput sgr0)\]"
# GREEN="$(tput setaf 2)"
# RESET="$(tput sgr0)"

HISTFILE="$HOME/.cache/bashhist"
if [ ! -f "$HISTFILE" ]; then # if bashhist file not found
    touch "$HISTFILE"
fi


alias ls='ls --color=auto'
# PS1='[\u@\h \W]\$ '
# PS1='${GREEN}\u \W > ${RESET}'
# PS1='\[\e]133;k;start_kitty\a\]\[\e]133;D;$?\a\e]133;A\a\]\[\e]133;k;end_kitty\a\]\[\e[01;32m\]\u@\h\[\e[01;34m\] \w \$\[\e[00m\] \[\e]133;k;start_suffix_kitty\a\]\[\e[5 q\]\[\e]2;\w\a\]\[\e]133;k;end_suffix_kitty\a\]'
PS1='\[\e[01;32m\]\u@\h\[\e[01;34m\] \w \$\[\e[00m\] '


# source shprofile
source ~/.config/shprofile

# source /usr/share/bash-completion/bash_completion

# BEGIN_KITTY_SHELL_INTEGRATION
if test -n "$KITTY_INSTALLATION_DIR" -a -e "$KITTY_INSTALLATION_DIR/shell-integration/bash/kitty.bash"; then source "$KITTY_INSTALLATION_DIR/shell-integration/bash/kitty.bash"; fi
# END_KITTY_SHELL_INTEGRATION
