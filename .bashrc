# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoredups:ignorespace

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=10000000
HISTFILESIZE=10000000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
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


# Prompt stuff ---------------------------------------------------------------

D=$'\[\e[1;34m\]'
LIGHTGREY=$'\[\e[1;30m\]'
PURPLE=$'\[\e[0;35m\]'
GREEN=$'\[\e[0;32m\]'
YELLOW=$'\[\e[0;33m\]'
WHITE=$'\[\e[0;37m\]'

hg_ps1() {
  hg prompt "${D}${PURPLE}[{${D}${PURPLE}{branch}}{${YELLOW}{status}}{${GREEN}{update}}${PURPLE}]${D}" 2> /dev/null
  #hg prompt "[{{branch}}{{status}}{{update}}]" 2> /dev/null
}

function parse_git_dirty
{
    status=$(git status 2> /dev/null)
    bits=''

	#☭⚡
    # Modified
    if [[ ${status} =~ "modified:" ]]; then
        bits="${bits}${YELLOW}*"
    fi
    # Untracked Files
    if [[ "${status}" =~ "Untracked files" ]]; then
        bits="${bits}${YELLOW}?"
    fi
    # Added but not committed
    if [[ "${status}" =~ "new file:" ]]; then
        bits="${bits}${YELLOW}+"
    fi
    # Local is ahead of the remote
    if [[ "${status}" =~ "Your branch is ahead of" ]]; then
        bits="${bits}${YELLOW}>"
    fi
    # File has been moved or renamed
    if [[ "${status}" =~ "renamed:" ]]; then
        bits="${bits}${YELLOW}~"
    fi

    # Add the colour to the 'bits'
    echo "${bits}"
}

function parse_git_revision {
    branch_details=$(git branch 2> /dev/null)
    if [ $? -eq 0 ]; then
        branch_name=$(echo -n "${branch_details}" | grep "*" 2> /dev/null | awk '{print $2}' 2> /dev/null)
        echo "${PURPLE}(${branch_name})$(parse_git_dirty)"
    fi
}

render_ps1() {
	VENV=""
    UENV=""
	if [ -n "${VIRTUAL_ENV}" ]; then
		VENV="(env)"
	fi

    if [ -n "${UNITY_ENV}" ]; then
		VENV="(U)"
	fi

    echo "\n${PURPLE}\h${D}[${GREEN}\w$(parse_git_revision)${D}]\n${YELLOW}\u${LIGHTGREY}(\t)${YELLOW}${VENV}${UENV}${WHITE}\$ "
    #echo "\n${PURPLE}\h[${debian_chroot}]${D}[${GREEN}\w${D}]\n${YELLOW}\u${LIGHTGREY}(\t)${YELLOW}${VENV}${UENV}${WHITE}\$ "
}

#PROMPT_COMMAND="$(echo "$PROMPT_COMMAND"|sed -e's/PS1="`render_ps1`";//g')"
PROMPT_COMMAND='PS1="`render_ps1`";'"$PROMPT_COMMAND"

#if [ "$color_prompt" = yes ]; then
#    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
#else
#    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
#fi
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
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

export qateam=~canonical-platform-qa

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

# This is a little annoying.
unset command_not_found_handle

#export TERM=rxvt-unicode
# I'm not 100% certain this is needed or best
#if [[ "${COLORTERM}" == "gnome-terminal" && "${TERM}" != "xterm"  ]]; then
#    export TERM="gnome-256color"
#fi
. ~/.bash_functions
alias valgrind-unity='G_SLICE=always-malloc G_DEBUG=gc-friendly valgrind --tool=memcheck --num-callers=50 --leak-check=full --track-origins=yes --log-file=unity-valgrind.`date +%Y%m%dT%H%M%S`.txt compiz --replace 2>&1 | tee /home/leecj2/unity-valgrind.`date +%Y%m%dT%H%M%S`.log'
alias sa="adb wait-for-device; adb root; adb wait-for-device; adb shell"
alias sd="adb forward tcp:2222 tcp:22; ssh-keygen -f /home/leecj2/.ssh/known_hosts -R [localhost]:2222; ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no phablet@localhost -p 2222"
PATH=$PATH:/usr/local/bin

DEBFULLNAME="Christopher Lee"
DEBEMAIL="chris.lee@canonical.com"
[ -r /home/leecj2/.byobu/prompt ] && . /home/leecj2/.byobu/prompt   #byobu-prompt#
