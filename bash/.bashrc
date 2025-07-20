# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth:erasedups

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=10000
HISTFILESIZE=20000

# store history immediately not only when session terminates
PROMPT_COMMAND='history -a'

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# define some colors (solarized)
tput sgr0; # reset colors
bold="\[$(tput bold)\]"
reset="\[$(tput sgr0)\]"
black="\[$(tput setaf 0)\]"
red="\[$(tput setaf 1)\]"
green="\[$(tput setaf 2)\]"
yellow="\[$(tput setaf 3)\]"
blue="\[$(tput setaf 4)\]"
magenta="\[$(tput setaf 5)\]"
cyan="\[$(tput setaf 6)\]"
white="\[$(tput setaf 7)\]"
brightblack="\[$(tput setaf 8)\]"
brightred="\[$(tput setaf 9)\]"
brightgreen="\[$(tput setaf 10)\]"
brightyellow="\[$(tput setaf 11)\]"
brightblue="\[$(tput setaf 12)\]"
brightmagenta="\[$(tput setaf 13)\]"
brightcyan="\[$(tput setaf 14)\]"
brightwhite="\[$(tput setaf 15)\]"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

export CLICOLOR=1
[ -f /etc/bash_completion.d/git-prompt ] && . /etc/bash_completion.d/git-prompt
export GIT_PS1_SHOWCOLORHINTS=1
export GIT_PS1_SHOWDIRTYSTATE=1
export GIT_PS1_SHOWUPSTREAM="auto"

PROMPT_COMMAND="echo; $PROMPT_COMMAND"

exit_code()
{
    code=$?
    if [[ $code != 0 ]]; then
    echo "exited $code"
    fi
}

PS1="\
${debian_chroot:+($debian_chroot)}\
${bold}${magenta}\u \
${white}at ${yellow}\h \
${white}in ${green}\w\
${yellow}\$(__git_ps1) \
${red}\$(exit_code) \
${reset}
\$ "

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
        # We have color support; assume it's compliant with Ecma-48
        # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
        # a case would tend to support setf rather than setaf.)
        color_prompt=yes
    else
        color_prompt=
    fi
fi

# if [ "$color_prompt" = yes ]; then
#     PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
# else
#     PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
# fi

unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
fi

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

[ -f "${HOME}/.bash_aliases" ] && . "${HOME}/.bash_aliases"

[ -d "${HOME}/.bash_aliases.d" ] && for snippet in "${HOME}/.bash_aliases.d"/*; do
    . "${snippet}"
done

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# Set up SSH auth socket
if [ -S "${XDG_RUNTIME_DIR}/ssh-agent.socket" ]; then
    export SSH_AUTH_SOCK="${XDG_RUNTIME_DIR}/ssh-agent.socket"
fi

# # Set up SSH auth socket and load keys
# if type -P ssh-agent &>/dev/null; then
#     [ -z "${SSH_AUTH_SOCK}" ] && eval $(ssh-agent)
#     [ -S "${HOME}"/.ssh/ssh_auth_sock ] || ln -sf "${SSH_AUTH_SOCK}" "${HOME}"/.ssh/ssh_auth_sock
#     loaded_keys=$(ssh-add -l) || loaded_keys=''
#     for keyfile in "${HOME}"/.ssh/id_{rsa,dsa,ecdsa,ed25519}; do
#         [ -r "${keyfile}" ] && (
#             fingerprint=$(ssh-keygen -l -f "${keyfile}" | cut -d ' ' -f2 | sed -e 's/\([/+]\)/\\\1/g')
#             echo "${loaded_keys}" | egrep -q "${fingerprint}" || ssh-add "${keyfile}"
#         )
#     done
#     unset loaded_keys keyfile
# fi

export PROCPS_FROMLEN=36

# dotfiles sort first; don't be a heathen
export LC_COLLATE=C

# need to set GPG_TTY or gpg signed git commits will explode
# No harm in setting this on systems that don't have gpg installed
export GPG_TTY=$(tty)

[ -f "${HOME}/.bashrc.local" ] && . "${HOME}/.bashrc.local"

# remove shell flow control as it's annoying AF
stty -ixon
bind -r "\C-s"
bind -r "\C-q"
