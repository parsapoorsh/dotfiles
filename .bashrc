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
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=10000
HISTFILESIZE=50000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

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

if [ "$color_prompt" = yes ]; then
    SC_COLOR_OFF="$(tput sgr0)"

    SC_BOLD="$(tput bold)"
    SC_UNDERLINE="$(tput smul)"

    SC_BLACK="$(tput setaf 0)"
    SC_RED="$(tput setaf 1)"
    SC_GREEN="$(tput setaf 2)"
    SC_YELLOW="$(tput setaf 3)"
    SC_BLUE="$(tput setaf 4)"
    SC_PURPLE="$(tput setaf 5)"
    SC_CYAN="$(tput setaf 6)"
    SC_WHITE="$(tput setaf 7)"

    if [ "$(id -u)" -eq 0 ]; then  # If root user
        PS1_COLOR1="$SC_RED"
    else
        PS1_COLOR1="$SC_YELLOW"
    fi
    PS1='\[$SC_BOLD$PS1_COLOR1\]\u@\h\[$SC_COLOR_OFF\]:\[$SC_BOLD$SC_BLUE\]\w\[$SC_COLOR_OFF\]\$ '
else
    PS1='\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

PS1="${debian_chroot:+($debian_chroot)}$PS1"

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
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -l'
alias lh='ls -lh'
alias la='ls -A'
alias l='ls -CF'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

if [ -f ~/.bash_aliases_private ]; then
    . ~/.bash_aliases_private
fi

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

if [ -f /usr/bin/bashacks ]; then
    . /usr/bin/bashacks
fi

# Added by LM Studio CLI (lms)
if [ -d "$HOME/.lmstudio/bin" ]; then
    export PATH="$PATH:$HOME/.lmstudio/bin"
fi

# alias get_idf='. $HOME/esp/esp-idf/export.sh'
get_idf() {
    local idf_script="$HOME/esp/esp-idf/export.sh"
    if [ -f "$idf_script" ]; then
        . "$idf_script"
    else
        echo "ESP-IDF not found: $idf_script does not exist."
        echo "Please install ESP-IDF or check the path."
    fi
}

conda_init() {
    local conda_base="$HOME/anaconda3"
    local conda_script="$conda_base/etc/profile.d/conda.sh"
    local conda_bin="$conda_base/bin"

    if [ -x "$conda_bin/conda" ]; then
        # Preferred: use conda hook if available
        __conda_setup="$("$conda_bin/conda" 'shell.bash' 'hook' 2>/dev/null)"
        if [ $? -eq 0 ]; then
            eval "$__conda_setup"
        elif [ -f "$conda_script" ]; then
            . "$conda_script"
        else
            export PATH="$conda_bin:$PATH"
        fi
        unset __conda_setup
    else
        echo "Conda not found: $conda_base not installed or conda executable missing."
    fi
}

export CCACHE_DIR=~/.ccache
export BROWSER=firefox
# GTK stuff
export $(dbus-launch)
export SAL_USE_VCLPLUGIN=gtk

# pyenv stuff
export PYENV_ROOT="$HOME/.pyenv"
if [ -d "$PYENV_ROOT/bin" ]; then
    export PATH="$PYENV_ROOT/bin:$PATH"

    # only run pyenv init if the command exists
    if command -v pyenv >/dev/null 2>&1; then
        eval "$(pyenv init - bash)"
    else
        echo "pyenv command not found, but $PYENV_ROOT/bin exist."
        echo "something is wrong!"
    fi
fi

cat yes-man.txt | fastfetch --file-raw -
