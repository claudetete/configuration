# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
export HISTCONTROL=ignoredups
# ... and ignore same sucessive entries.
export HISTCONTROL=ignoreboth

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
#shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
#[ -x /usr/bin/lesspipe ] && eval "$(lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
#if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
#    debian_chroot=$(cat /etc/debian_chroot)
#fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
xterm-color)
    PS1='${\[\033[01;36m\]\u[\033[01;32m\]@~\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
    ;;
*)
    PS1='\e[0;36m\u\e[0;0m@\e[0;32m\w\e[0;0m\$ '
    ;;
esac

function settitle() { echo -ne "\e]2;$@\a\e]1;$@\a"; }

# Comment in the above and uncomment this below for a color prompt
#PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '

# If this is an xterm set the title to user@host:dir
#case "$TERM" in
#xterm*|rxvt*)
#    PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD/$HOME/~}\007"'
#    PROMPT_COMMAND='echo -ne "Make"'
#    ;;
#*)
#    ;;
#esac

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

#if [ -f ~/.bash_aliases ]; then
#    . ~/.bash_aliases
#fi

# enable color support of ls and also add handy aliases
if [ "$TERM" != "dumb" ]; then
    eval "`dircolors -b`"
    alias ls='ls --color=auto --classify --show-control-chars --human-readable'
    alias la='ls -la'
    alias ll='ls -l'
    alias lh='ls -lah'
    alias c='cd ..'
    alias e='emacs -nw'
#    alias se='sudo emacs -nw'
#    alias b='cd /usr/lynxos-178/2.2.0/ppc_dev/  && . SETUP.bash && cd ~/tosa-calculateur_msp/S1/MKS/lynxos-178'
#    alias ma='make PROBE=1 all'
#    alias mc='make PROBE=1 clean'
#    alias md='make PROBE=1 depend'


    #alias dir='ls --color=auto --format=vertical'
    #alias vdir='ls --color=auto --format=long'
fi

alias cleartool='C:\Program Files\IBM\RationalSDLC\ClearCase\bin\cleartool.exe'

#alias x='XWin -multiwindow'

#alias m='/cygdrive/d/cygwin/usr/bin/synergy/ccm_make.exe'

# some more ls aliases
#alias ll='ls -l'
#alias la='ls -A'
#alias l='ls -CF'

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi


##KANETON
#export KANETON_PYTHON=/usr/bin/python
#export KANETON_HOST=linux/ia32
#export KANETON_USER=student
#export KANETON_PLATFORM=ibm-pc
#export KANETON_ARCHITECTURE=ia32/educational
#export OOO_FORCE_DESKTOP=gnome

#### PATH
### MBDA
## CYGWIN
# chemin de cygwin
#PREFIX=/cygdrive/d/Users/ctete/tools/
# racine de cygwin
#export CYGWIN_ROOT=$PREFIX/cygwin
# chemin necessaire pour le fonctionnement de cygwin
#export CYGWIN=$CYGWIN_ROOT
# ajout de /bin dans le path pour avoir toutes les commandes
#export PATH="$PREFIX/cygwin/bin"
# ajout de /lib pour pouvoir compiler avec les lib de cygwin
#export LD_LIBRARY_PATH="$PREFIX/cygwin/lib"
# path avec mingw et gcc 4.4
#export PATH="$PREFIX/mingw/bin:$PATH"
##
### MAGNETI MARELLI
## CYGWIN
# chemin de cygwin
PREFIX=/cygdrive/d
# racine de cygwin
export CYGWIN_ROOT=$PREFIX/cygwin
# chemin necessaire pour le fonctionnement de cygwin
export CYGWIN=$CYGWIN_ROOT
# ajout de /bin dans le path pour avoir toutes les commandes
export PATH="$PREFIX/cygwin/bin"
#
## SYNERGY
# chemin de travail de synergy
#export SYNERGY_WORKING="/cygdrive/d/ccm_wa"
#export SYNERGY_WORKING_WIN32="d:/ccm_wa"
# chemin de travail pour NSF
#export NSFLL_WORKING="$SYNERGY_WORKING/NSF/NSF_LL"
#export NSFLL_WORKING_WIN32="$SYNERGY_WORKING_WIN32/NSF/NSF_LL"
#chemin de travail pour NBNF_LL
#export NSFNBNF_WORKING="$SYNERGY_WORKING/NBNF/NBNF_LL"
#export NSFNBNF_WORKING_WIN32="$SYNERGY_WORKING_WIN32/NBNF/NBNF_LL"
# chemin de travail pour NBNF_HL
#export NBNFHL_WORKING="$SYNERGY_WORKING/NBNF/NBNF_HL"
#export NBNFHL_WORKING_WIN32="$SYNERGY_WORKING_WIN32/NBNF/NBNF_HL"
# chemin de travail temporaire pour XX
#export NSF_OR_NBNF_TMP_WORKING="$SYNERGY_WORKING/NBNF/NBNF_LL_X008"
#
# numero de version de NSF LL & NSF HL (nsfll)
#NSFLL_VERSION=`ls $NSFLL_WORKING | grep CLIENT | cut --delimiter='_' -f 4 | cut -c -3`
# numero de version de NBNF LL (nsfnbnf) !! version avec dizaines !!
#NSFNBNF_VERSION=`ls $NSFNBNF_WORKING | grep CLIENT | cut --delimiter='_' -f 4 | cut -c -4`
# numero de version de NBNF HL (nbnfhl)
#NBNFHL_VERSION=`ls $NBNFHL_WORKING | grep CLIENT | cut --delimiter='_' -f 5 | cut -c -3`
# numero de version doc de NSF LL & NSF HL (nsfll)
#NSFLL_DOC_VERSION=`ls $NSFLL_WORKING/Doc | grep _DOC_SW | cut --delimiter='_' -f 6 | cut -c -3`
# numero de version doc de NBNF LL (nsfnbnf) !! version avec dizaines
#NSFNBNF_DOC_VERSION=`ls $NSFNBNF_WORKING/Doc | grep _DOC_SW | cut --delimiter='_' -f 6 | cut -c -4`
# numero de version doc de NBNF HL (nbnfhl)
#NBNFHL_DOC_VERSION=`ls $NBNFHL_WORKING/Doc | grep_DOC_SW | cut --delimiter='_' -f 7 | cut -c -3`
# numero de version de XX
#NSF_OR_NBNF_TMP_VERSION=`ls $NSF_OR_NBNF_TMP_WORKING | grep CLIENT | cut --delimiter='_' -f 4 | cut -c -3`
#
# chemin de travail pour NSF
#export NSFLL_BIN="$NSFLL_WORKING/NSF_CLIENT/out"
# chemin de travail pour NBNF_LL
#export NSFNBNF_BIN="$NSFNBNF_WORKING/NSFNBNF_CLIENT/out"
# chemin de travail pour NBNF_HL
#export NBNFHL_BIN="$NBNFHL_WORKING/NBNF_CLIENT_HL-tete_nbnfhl_$NBNFHL_VERSION/NBNF_CLIENT_HL/out"
# chemin de travail temporaire pour XX
#export NSF_OR_NBNF_TMP_BIN="$SYNERGY_WORKING/NBNF/NBNF_LL_X008"
#
# chemin de cfg pour NSF
#export NSFLL_CFG="$NSFLL_WORKING/Cfg/NSF_CLIENT_cfg"
# chemin de cfg pour NBNF_LL
#export NSFNBNF_CFG="$NSFNBNF_WORKING/Cfg/NSFNBNF_CLIENT_cfg-tete_nsfnbnf_$NSFNBNF_VERSION/NSFNBNF_CLIENT_cfg"
# chemin de cfg pour NBNF_HL
#export NBNFHL_CFG="$NBNFHL_WORKING/Cfg/NBNF_CLIENT_HL_cfg-tete_nbnfhl_$NBNFHL_VERSION/NBNF_CLIENT_HL_cfg"
#
# chemin de doc pour NSF
#export NSFLL_DOC="$NSFLL_WORKING/Doc/NSF_DOC_SW-tete_nsf_doc_$NSFLL_DOC_VERSION/NSF_DOC_SW"
# chemin de cfg pour NBNF_LL
#export NSFNBNF_DOC="$NSFNBNF_WORKING/Doc/NSFNBNF_DOC_SW-tete_nsfnbnf_doc_$NSFNBNF_DOC_VERSION/NSFNBNF_DOC_SW"
# chemin de cfg pour NBNF_HL
#export NBNFHL_DOC="$NBNFHL_WORKING/Doc/NSF_NBNF_DOC_SW-tete_nsf_nbnfhl_$NBNFHL_VERSION/NBNF_CLIENT_HL_cfg"
#
# chemin de PTF_VW pour NSF
#export NSFLL_PTF_VW="$NSFLL_WORKING/PTF_VW/PTF_VW-tete_ptfvw_nsf/PTF_VW/documentation"
# chemin de PTF_VW pour NBNF_LL
#export NSFNBNF_PTF_VW="$NSFNBNF_WORKING/Doc/NSFNBNF_DOC_SW-tete_nsfnbnf_doc_$NSFNBNF_DOC_VERSION/NSFNBNF_DOC_SW"
# chemin de PTF_VW pour NBNF_HL
#export NBNFHL_PTF_VW="$NBNFHL_WORKING/Doc/NSF_NBNF_DOC_SW-tete_nsf_nbnfhl_$NBNFHL_VERSION/NBNF_CLIENT_HL_cfg"
#
# chemin du serveur pour flasher les binaires
#export SYNERGY_SERVER_WORKING="/cygdrive/z/40_SOFTWARE/99_Users/tete/nsf120nbnf324"
# chemin de serveur pour NSF
#export NSFLL_SERVER="$SYNERGY_SERVER_WORKING/nsfll"
# chemin de serveur pour NBNF_LL
#export NSFNBNF_SERVER="$SYNERGY_SERVER_WORKING/nsfnbnf"
# chemin de serveur pour NBNF_HL
#export NBNFHL_SERVER="$SYNERGY_SERVER_WORKING/nbnfhl"
# chemin de serveur pour XX
#export NSF_OR_NBNF_TMP_SERVER="$SYNERGY_SERVER_WORKING/nsfnbnf"
#
# chemin de serveur pour les binaires de NSF
#export NSFLL_SERVER_BIN="$NSFLL_SERVER/bin"
# chemin de serveur pour les binaires NBNF_LL
#export NSFNBNF_SERVER_BIN="$NSFNBNF_SERVER/bin"
# chemin de serveur pour les binaires NBNF_HL
#export NBNFHL_SERVER_BIN="$NBNFHL_SERVER/bin"
# chemin de serveur pour les docs de NSF
#export NSFLL_SERVER_DOC="$NSFLL_SERVER/doc"
# chemin de serveur pour les docs NBNF_LL
#export NSFNBNF_SERVER_DOC="$NSFNBNF_SERVER/doc"
# chemin de serveur pour les docs NBNF_HL
#export NBNFHL_SERVER_DOC="$NBNFHL_SERVER/doc"
# chemin de serveur pour XX
#export NSF_OR_NBNF_TMP_SERVER_BIN="$NSF_OR_NBNF_TMP_SERVER/bin for WinIDEA/X008"
#
# chemin des binaires synergy
#export SYNERGY_BIN="/cygdrive/c/Program Files/Telelogic/Telelogic Synergy 7.0/bin"
#mkdir -p ~/bin/synergy
#
#export PATH="/cygdrive/d/cygwin/usr/bin/synergy/bin/synergy;/cygdrive/d/cygwin/usr/bin/synergy/bin/synergy/util;$PATH"
