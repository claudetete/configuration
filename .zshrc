# .zshrc --- config file for zsh shell

# Copyright (c) 2006-2013 Claude Tete
#
# This program is free software; you can redistribute it and/or modify it under
# the terms of the GNU General Public License as published by the Free Software
# Foundation ; either version 3, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY ; without even the implied warranty of MERCHANTABILITY or
# FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
# more details.
#
# You should have received a copy of the GNU General Public License along with
# this program; see the file COPYING.  If not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301,
# USA.

# Author: Claude TETE <claude.tete@gmail.com>
# Version: 4.1
# Created: January 2013
# Last-Updated: December 2006

# Change Log:
#  4.1 new alias for clearcase command
#  4.0 set subversion editor
#  3.9 add path for Alstom Transport
#  3.8 remove bug about completion
#  3.7 add some command for telelogic synergy
#  3.6 add new path for a new project
#  3.5 add new alias to compile and share synergy script
#  3.4 update path and alias for search and etags
#  3.3 add alias for search and backup
#  3.2 add path for project MagnetiMarelli
#  3.1 add alias for script "copy.bin.sh"
#  3.0 new completion (with zsh-newuser-install)
#  2.5 new bindings (with zkbd) + dir history + alias
#  2.0 correction + bindings + alias
#  1.0 configuration completion + alias
#  0.5 prompt + system + color + alias
#  0.1 creation from scratch

#
##
###
#### SYSTEM
# desactive les bips
#xset b off
unsetopt beep nomatch
#
# augmente la vitesse du curseur
# 300 ms avant repetition et 100ms entre chaque repetition (pas des ms)
#xset r rate 300 100
#
# editeur par defaut
export VISUAL=emacs
export EDITOR=emacs
export INPUTRC=$HOME/.inputrc

# subversion editor
export SVN_EDITOR=nano

# to avoid message in french
export LANG=en_US

# cd automatique (sans avoir besoin de taper cd)
setopt autocd notify

#
##
###
#### BINDING
## faire pour un nouveau terminal
##   $zsh -f /usr/share/zsh/4.3.9/functions/zkbd

# ';|' signifie que apres le cas, on recherche une autre solution
# ';;' signifie que apres le cas, on quitte le 'case'
case "$TERM" in
    #
    ## pour rxvt sous cygwin
    rxvt*)
        source ~/.zkbd/rxvt-:0
        #unsetopt MULTIBYTE
        ;|
    #
    ## pour xterm sous cygwin
    xterm*)
        source ~/.zkbd/xterm-127.0.0.1:0.0
        #bindkey -m
        #unsetopt MULTIBYTE
        ;|
    # pour console2 sous windows
    ## utilisation du script autohotkey pour binder les touches
    nutc*)
        #source ~/.zkbd/console2.tmp
        #unsetopt MULTIBYTE
        ;|
    #
    ## pour tous
    *)
        # touche a (re)configurer qui ne fonctionne jamais correctement
        [[ -n ${key[Delete]} ]] && bindkey "${key[Delete]}" delete-char-or-list
        [[ -n ${key[Insert]} ]] && bindkey "${key[Insert]}" delete-char-or-list
        [[ -n ${key[Home]} ]] && bindkey "${key[Home]}" beginning-of-line
        [[ -n ${key[End]} ]] && bindkey "${key[End]}" end-of-line
        [[ -n ${key[Backspace]} ]] && bindkey "${key[Backspace]}" backward-delete-char
        [[ -n ${key[Back]} ]] && bindkey "${key[Backspace]}" backward-delete-char
        ;;
esac
#
## Ancien reglage
# Binding
# Home key
#bindkey "\e[7~" beginning-of-line
#bindkey "\e[1~" beginning-of-line
#bindkey "\eOH" beginning-of-line
#bindkey "\e[H" beginning-of-line
#
# End key
#bindkey "\e[8~" end-of-line
#bindkey "\e[4~" end-of-line
#bindkey "\eOF" end-of-line
#bindkey "\e[F" end-of-line
#
# Delete key
#bindkey "^?" delete-char-or-list

## emacs shortcuts
bindkey '\eF' emacs-forward-word
bindkey '\eB' emacs-backward-word

#
##
###
#### COLOR
# pour avoir plus de couleur dans emacs
#export TERM=xterm-256color

# chargement des couleurs
autoload -U colors
colors
#
# defaut
ColorDefault="%{$reset_color%}"
# rouge
ColorRed="%{$fg[red]%}"
# cyan (bleu ciel)
ColorCyan="%{$fg[cyan]%}"
# jaune
ColorYellow="%{$fg[yellow]%}"
# vert
ColorGreen="%{$fg[green]%}"
# magenta
ColorMagenta="%{$fg[magenta]%}"

#
##
###
#### PROMPT
# prompt perso
# username@CheminCourant DerniereErreur $ <commande>
# ^Jaune^^B^^^^^Vert^^^^ ^^^^^Rouge^^^^   ^^Blanc^^^
PROMPT="${ColorYellow}%n${ColorDefault}@${ColorGreen}%~${ColorDefault}%0(?..${ColorRed}%?${ColorDefault})${ColorDefault}$ "
#      PROMPT="%n@%~$ "


#
##
###
#### COMPLETION
# Schema de completion
#   fonctionnement
#     1ere tabulation : complete jusqu'au bout de la partie commune et
#                       propose une liste de choix
#     2eme tabulation : complete avec le 1er item de la liste
#                       (on peut naviguer avec les fleches !!)
#     3eme tabulation : complete avec le 2eme item de la liste, etc...
#
## ??
#autoload -Uz compinit
#compinit
#
## ajoute des espaces quand la completion se fait au milieu d'un mot
#zstyle ':completion:*' add-space true
#zstyle ':completion:*' completer _expand _complete _ignored _match _correct _approximate _prefix
## complete en premier par prefix puis dans le mot
#zstyle ':completion:*' expand prefix
# trier par nom
zstyle ':completion:*' file-sort name
zstyle ':completion:*' group-name ''
# ignore le dossier courant lors de '../'
zstyle ':completion:*' ignore-parents parent pwd
# couleur dans la liste (differencie les dossiers/fichiers etc..)
zstyle ':completion:*' list-colors ''
#
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' list-suffixes true
zstyle ':completion:*' match-original both
# ne prend pas en compte la casse
zstyle ':completion:*' matcher-list 'm:{[:lower:]}={[:upper:]}' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'r:|[._-]=** r:|=**'
# permet une correction jusqu'a 1 erreur
zstyle ':completion:*' max-errors 1 not-numeric
zstyle ':completion:*' prompt '%e erreur(s), debile'
# naviguer avec les fleches dans la liste
zstyle ':completion:*' menu select=3
zstyle ':completion:*' original true
zstyle ':completion:*' preserve-prefix '//[^/]##/'
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
## affiche le dossier .. pour les faineant
#zstyle ':completion:*' special-dirs true
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' word true
#zstyle :compinstall filename '/cygdrive/h/.zshrc'
# ??
unsetopt list_ambiguous
# completion sur les fichiers caches
setopt glob_dots
#
## Ancien reglage
## correction
#zstyle ':completion:*:corrections' format '%B%d (errors : %e)%b'
## autorise un caractere sur trois a etre une erreur de typo
#zstyle -e ':completion:*:approximate:*' max-errors par 'reply=( $(( ($#PREFIX+$#SUFFIX)/3 )) numeric )'
#
# ajoute les caracteres du globbing
setopt extendedglob
#
## complete aussi au milieu du mot
#setopt completeinword
#
## et bouge le curseur vers le milieu
#setopt no_alwaystoend

#
##
###
#### CORRECTION
# correction orthographique
setopt correct

#
##
###
#### HISTORY
## Historique des commandes (recherche dans l'historique avec '!')
## Ancien reglage
#export HISTORY=5000
#export SAVEHIST=5000
#export HISTSIZE=1000
#export HISTFILE=$HOME/.history
#
# fichier de sauvegarde de l'historique
HISTFILE=~/.history
#
# taille de l'historique par shell
HISTSIZE=10000
#
# taille de l'historique dans le fichier de sauvegarde
SAVEHIST=10000
#
# ignore les doublon dans l'historique
setopt HIST_IGNORE_DUPS
setopt hist_verify

## Historique des repertoires visites (pas simple a utiliser)
# historique en tourniquet (empile a la fin sur la droite)
# 'cd -#' va au repertoire a gauche avec #=0 et
#                         au deuxieme a gauche avec #=1 ...
# 'cd +#' va au repertoire a droite avec #=0 et
#                         au deuxieme a droite avec #=1 ...
#
# ajoute un repertoire automatiquement avec la commande 'cd'
setopt auto_pushd
#
# ajoute un repertoire sans message
setopt pushd_silent
#
# ignore les repertoires en double
setopt pushd_ignore_dups
#
# historique de 5 repertoires
export DIRSTACKSIZE=5

#
##
###
#### WORKING ENVIRONMENT
##    MBDA
#WORKING_ENVIRONMENT="MBDA Missile Systems"
## MAGNETI MARELLI
#WORKING_ENVIRONMENT="MAGNETI MARELLI"
# ALSTOM TRANSPORT
WORKING_ENVIRONMENT="ALSTOM Transport"

#
##
###
#### PATH
# ';|' signifie que apres le cas, on recherche une autre solution
# ';;' signifie que apres le cas, on quitte le 'case'
case "$WORKING_ENVIRONMENT" in
    ##    MBDA Missile Systems
    MBDA*)
        ## CYGWIN
        # chemin de cygwin
        PREFIX=/cygdrive/d/Users/ctete/tools/
        # racine de cygwin
        export CYGWIN_ROOT=$PREFIX/cygwin
        # chemin necessaire pour le fonctionnement de cygwin
        export CYGWIN=$CYGWIN_ROOT
        # ajout de /bin dans le path pour avoir toutes les commandes
        export PATH="$PREFIX/cygwin/bin"
        # ajout de /lib pour pouvoir compiler avec les lib de cygwin
        export LD_LIBRARY_PATH="$PREFIX/cygwin/lib"
        # path avec mingw et gcc 4.4
        export PATH="$PREFIX/mingw/bin:$PATH"
        ;;

    ## MAGNETI MARELLI
    MAGNETI*)
        ## CYGWIN
        # chemin de cygwin
        PREFIX=/cygdrive/d
        # racine de cygwin
        export CYGWIN_ROOT=$PREFIX/cygwin
        # chemin necessaire pour le fonctionnement de cygwin
        export CYGWIN=$CYGWIN_ROOT
        # ajout de /bin dans le path pour avoir toutes les commandes
        export PATH="/cygdrive/d/doxygen/bin:/cygdrive/d/Graphviz\ 2.28/bin:$PREFIX/cygwin/bin:/cygdrive/c/WINDOWS:/cygdrive/c/WINDOWS/System32:$PATH"

        export PATH="$PATH:/cygdrive/c/WINDOWS/Microsoft.NET/Framework/v3.5"

        ## SYNERGY
        # chemin de travail de synergy
        export SYNERGY_WORKING="/cygdrive/d/ccm_wa"
        export SYNERGY_WORKING_WIN32="d:/ccm_wa"
        # chemin de travail pour NSF
        export NSF_WORKING="$SYNERGY_WORKING/NSF/NSF"
        export NSF_WORKING_2011="$SYNERGY_WORKING/NSF/NSF_2011"
        export NSF_WORKING_WIN32="$SYNERGY_WORKING_WIN32/NSF/NSF"
        # chemin de travail pour NBNF_LL
        export NBNFLL_WORKING="$SYNERGY_WORKING/NBNF/NBNF_LL"
        export NBNFLL_WORKING_WIN32="$SYNERGY_WORKING_WIN32/NBNF/NBNF_LL"
        # chemin de travail pour NBNF_HL
        export NBNFHL_WORKING="$SYNERGY_WORKING/NBNF/NBNF_HL"
        export NBNFHL_WORKING_2011="$SYNERGY_WORKING/NBNF/NBNF_HL_2011"
        export NBNFHL_WORKING_WIN32="$SYNERGY_WORKING_WIN32/NBNF/NBNF_HL"
        # chemin de travail pour NBNF_HL root
        export NBNFHL_ROOT_WORKING="$SYNERGY_WORKING/NBNF/NBNF_HL_root"
        export NBNFHL_ROOT_WORKING_WIN32="$SYNERGY_WORKING_WIN32/NBNF/NBNF_HL_root"
        # chemin de travail pour E-CAR
        export ECAR_WORKING="$SYNERGY_WORKING/ECAR"
        export ECAR_WORKING_WIN32="$SYNERGY_WORKING_WIN32/ECAR"
        # chemin de travail pour XL1
        export XL1_WORKING="$SYNERGY_WORKING/XL1"
        export XL1_WORKING_WIN32="$SYNERGY_WORKING_WIN32/XL1"
        ## chemin de travail temporaire pour XX
        #export NSF_OR_NBNF_TMP_WORKING="$SYNERGY_WORKING/NBNF/NBNF_LL_X008"

        # chemin de travail pour NSF
        export NSF_ROOT="$NSF_WORKING/NSF_CLIENT"
        export NSF_ROOT_2011="$NSF_WORKING_2011/NSF_CLIENT"
        export NSF_ROOT_RELATIVE="NSF_CLIENT"
        export NSF_ROOT_RELATIVE_2011="NSF_CLIENT"
        # chemin de travail pour NBNF_LL
        export NBNFLL_ROOT="$NBNFLL_WORKING/NBNFLL_CLIENT"
        export NBNFLL_ROOT_RELATIVE="NBNFLL_CLIENT"
        # chemin de travail pour NBNF_HL
        export NBNFHL_ROOT="$NBNFHL_WORKING/NBNF_CLIENT_HL"
        export NBNFHL_ROOT_2011="$NBNFHL_WORKING_2011/NBNF_CLIENT_HL"
        export NBNFHL_ROOT_RELATIVE="NBNF_CLIENT_HL"
        export NBNFHL_ROOT_RELATIVE_2011="NBNF_CLIENT_HL"
        # chemin de travail pour NBNF_HL root
        export NBNFHL_ROOT_ROOT="$NBNFHL_ROOT_WORKING/NBNF_root_HL"
        # chemin de travail pour E-CAR
        export ECAR_ROOT="$ECAR_WORKING/ENSF_CLIENT"
        export ECAR_ROOT_RELATIVE="ENSF_CLIENT"
        # chemin de travail pour XL1
        export XL1_ROOT="$XL1_WORKING/XL1_CLIENT"
        export XL1_ROOT_RELATIVE="XL1_CLIENT"

        # chemin de binaire pour NSF
        export NSF_BIN="$NSF_ROOT/out"
        export NSF_BIN_2011="$NSF_ROOT_2011/out"
        export NSF_BIN_RELATIVE="$NSF_ROOT_RELATIVE/out"
        export NSF_BIN_RELATIVE_2011="$NSF_ROOT_RELATIVE/out"
        # chemin de binaire pour NBNF_LL
        export NBNFLL_BIN="$NBNFLL_ROOT/out"
        export NBNFLL_BIN_RELATIVE="$NBNFLL_ROOT_RELATIVE/out"
        # chemin de binaire pour NBNF_HL
        export NBNFHL_BIN="$NBNFHL_ROOT/out"
        export NBNFHL_BIN_RELATIVE="$NBNFHL_ROOT_RELATIVE/out"
        export NBNFHL_BIN_2011="$NBNFHL_ROOT_2011/out"
        export NBNFHL_BIN_RELATIVE_2011="$NBNFHL_ROOT_RELATIVE_2011/out"
        # chemin de binaire pour E-CAR
        export ECAR_BIN="$ECAR_ROOT/out"
        export ECAR_BIN_RELATIVE="$ECAR_ROOT_RELATIVE/out"
        # chemin de binaire pour XL1
        export XL1_BIN="$XL1_ROOT/out"
        export XL1_BIN_RELATIVE="$XL1_ROOT_RELATIVE/out"
        ## chemin de travail temporaire pour XX
        #export NSF_OR_NBNF_TMP_BIN="$SYNERGY_WORKING/NBNF/NBNF_LL_X008"

        # chemin de cfg pour NSF
        export NSF_CFG="$NSF_WORKING/Cfg/NSF_CLIENT_cfg"
        export NSF_CFG_2011="$NSF_WORKING_2011/Cfg/NSF_CLIENT_cfg"
        export NSF_CFG_RELATIVE="Cfg/NSF_CLIENT_cfg"
        export NSF_CFG_RELATIVE_2011="Cfg/NSF_CLIENT_cfg"
        # chemin de cfg pour NBNF_LL
        export NBNFLL_CFG="$NBNFLL_WORKING/Cfg/NBNFLL_CLIENT_cfg"
        export NBNFLL_CFG_RELATIVE="Cfg/NBNFLL_CLIENT_cfg"
        # chemin de cfg pour NBNF_HL
        export NBNFHL_CFG="$NBNFHL_WORKING/Cfg/NBNF_CLIENT_HL_cfg"
        export NBNFHL_CFG_2011="$NBNFHL_WORKING_2011/Cfg/NBNF_CLIENT_HL_cfg"
        export NBNFHL_CFG_RELATIVE="Cfg/NBNF_CLIENT_HL_cfg"
        export NBNFHL_CFG_RELATIVE_2011="Cfg/NBNF_CLIENT_HL_cfg"
        # chemin de cfg pour E-CAR
        export ECAR_CFG="$ECAR_WORKING/Cfg/ENSF_CLIENT_cfg"
        export ECAR_CFG_RELATIVE="Cfg/ENSF_CLIENT_cfg"
        # chemin de cfg pour XL1
        export XL1_CFG="$XL1_WORKING/Cfg/XL1_CLIENT_cfg"
        export XL1_CFG_RELATIVE="Cfg/XL1_CLIENT_cfg"

        # chemin du serveur pour flasher les binaires
        export SYNERGY_SERVER_WORKING="/cygdrive/z/40_SOFTWARE/99_Users/tete/nsf120nbnf324"
        # chemin de serveur pour NSF
        export NSF_SERVER="$SYNERGY_SERVER_WORKING/nsf"
        # chemin de serveur pour NBNF_LL
        export NBNFLL_SERVER="$SYNERGY_SERVER_WORKING/nbnfll"
        # chemin de serveur pour NBNF_HL
        export NBNFHL_SERVER="$SYNERGY_SERVER_WORKING/nbnfhl"
        # chemin de serveur pour E-CAR
        export ECAR_SERVER="$SYNERGY_SERVER_WORKING/ecar"
        # chemin de serveur pour XL1
        export XL1_SERVER="$SYNERGY_SERVER_WORKING/xl1"
        ## chemin de serveur pour XX
        #export NSF_OR_NBNF_TMP_SERVER="$SYNERGY_SERVER_WORKING/nsfnbnf"

        # chemin de serveur pour les binaires de NSF
        export NSF_SERVER_BIN="$NSF_SERVER/bin"
        # chemin de serveur pour les binaires NBNF_LL
        export NBNFLL_SERVER_BIN="$NBNFLL_SERVER/bin"
        # chemin de serveur pour les binaires NBNF_HL
        export NBNFHL_SERVER_BIN="$NBNFHL_SERVER/bin"
        # chemin de serveur pour les binaires E-CAR
        export ECAR_SERVER_BIN="$ECAR_SERVER/bin"
        # chemin de serveur pour les binaires XL1
        export XL1_SERVER_BIN="$XL1_SERVER/bin"

        # chemin des binaires de synergy pour synergy
        export CCM_HOME="C:\Program Files\Telelogic\Telelogic Synergy 7.0"
        export SYNERGY_BIN="/cygdrive/c/Program Files/Telelogic/Telelogic Synergy 7.0/bin"
        export PATH="/cygdrive/c/Program Files/Telelogic/Telelogic Synergy 7.0/bin:$PATH"
        export PATH="/cygdrive/c/Program Files/Telelogic/Telelogic Synergy 7.0/bin/util:$PATH"

        # COMPILER PATH
        export COMPILER_PATH='\\frcha3lic1\compiler'
        ;;

    ## ALSTOM TRANSPORT
    ALSTOM*)
        ## CYGWIN
        # chemin de cygwin
        PREFIX=/cygdrive/d
        # racine de cygwin
        export CYGWIN_ROOT=$PREFIX/cygwin
        # chemin necessaire pour le fonctionnement de cygwin
        export CYGWIN=$CYGWIN_ROOT
        # ajout de /bin dans le path pour avoir toutes les commandes
        export PATH="$PREFIX/cygwin/bin:/cygdrive/c/WINDOWS:/cygdrive/c/WINDOWS/System32:$PATH"
        # to use GNU Global
        export PATH="/cygdrive/d/Users/ctete/tools/.emacs.d/plugins/gnu_global_622wb/bin:$PATH"
        # to use python win32
        #export PATH="/cygdrive/c/Python27/:$PATH"

        ## PYTHON
        export PYTHONIOENCODING=iso8859_15

        ## CLEARCASE
        # to use gui clearcase
        export PATH="/agl/liv/bin:$PATH"
        export ATRIA_FORCE_GUI="1"
        export CLIPBOARD=""
        # chemin de travail de clearcase
        export CLEARCASE_MYVIEW="/cygdrive/z"
        export CLEARCASE_MYVIEW_WIN32="z:"

        # path of source code for PM4S project
        export PM4S_WORKING="$CLEARCASE_MYVIEW/a2kc/soft/ccn4/ccn4_pm4s"
        # path of source code for PM4S project
        export PM4S_BIN="$CLEARCASE_MYVIEW/a2kc/liv/bin/ccn4/pm4s.bin@@/"
        # path of test for PM4S project
        export PM4S_TEST_WORKING="$CLEARCASE_MYVIEW/a2kc/test/CCN4/test_s/pm4s"
        # path of documentation for PM4S project
        export PM4S_DOC_WORKING="$CLEARCASE_MYVIEW/a2kc/doc/qualite/pm4s"

        # path of source code for PM4S project
        export PARPM4S_WORKING="$CLEARCASE_MYVIEW/a2kc/soft/ccn4/parPM4S"
        # path of source code for PM4S project
        export PARPM4S_BIN="$CLEARCASE_MYVIEW/a2kc/liv/config/ccn4/parPM4S"

        # path of test "Checker" for PM4S project
        export PM4S_CHECKER="$PM4S_TEST_WORKING/checker"
        # path of test "RTRT script" for PM4S project
        export PM4S_RTRT="$PM4S_TEST_WORKING/RTRT"
        # path of test "QA-C" for PM4S project
        export PM4S_QAC="$PM4S_TEST_WORKING/QA-C"
        # path of executable "Checker"
        export PM4S_CHECKER_BIN="$CLEARCASE_MYVIEW/step/liv/scvr_check/bin"

        # path of source code for PUMA project
        export PUMA_WORKING="$CLEARCASE_MYVIEW/a2kc/soft/ccn4/ccn4_puma"
        # path of test for PUMA project
        export PUMA_TEST_WORKING="$CLEARCASE_MYVIEW/a2kc/test/CCN4/test_s/puma"
        # path of documentation for PUMA project
        export PUMA_DOC_WORKING="$CLEARCASE_MYVIEW/a2kc/doc/qualite/puma"
        # path of test "RTRT script" for PUMA project
        export PUMA_RTRT="$PUMA_TEST_WORKING/TestU/sharc/ccu_puma"

        # path of parPUMA project
        export PARPUMA_WORKING="$CLEARCASE_MYVIEW/a2kc/test/CCN4/test_s/puma/config/ParPUMA/sources"
        # path of parPUMA makefile
        export PARPUMA_MAKE="$PARPUMA_WORKING/ParametriseurPUMA"

        # path of source code for PUMA project
        export PUMAO2KC_WORKING="$CLEARCASE_MYVIEW/o2kc/soft/sharc/ccu_puma"
        ;;
esac

#
##
###
####  ALIAS
## ls (couleurs, trier...) /* '-h' = --human-readable */
# liste avec les options par defaut pour moi
alias ls='ls --human-readable --classify --show-control-chars --color'
# liste en colonne, +fichiers caches
alias la='ls -la'
# liste en colonne, +fichiers caches (eviter erreur)
alias al='la'
alias lq='la'
alias ql='la'
# liste en colonne, +fichiers caches, +recursive !! peut etre long !!
alias lr='la -h -R'
# liste en colonne
alias ll='ls -l'
alias l='ll'
# liste sans prendre '.' et '..', ignore les "*~", trie par taille
alias lc='ls -lABS'
# liste avec seulement les repertoires
alias lr='la -d'

#
##
### navigation dans le repertoire (faineant)
# revenir dans le dossier parent
alias c='cd ..'
# tourner dans le tourniquet de l'historique des repertoires
alias cc='cd -0'
## aller dans les repertoires de travail
# ';|' signifie que apres le cas, on recherche une autre solution
# ';;' signifie que apres le cas, on quitte le 'case'
case "$WORKING_ENVIRONMENT" in
    MAGNETI*)
        alias s='cd $NSF_WORKING'
        alias n='cd $NBNFLL_WORKING'
        alias h='cd $NBNFHL_WORKING'
        alias e='cd $ECAR_WORKING'
        alias x='cd $XL1_WORKING'
        alias d='cd /cygdrive/c/Documents\ and\ Settings/tete/Desktop/tmp'
        alias u='cd /cygdrive/d/cygwin/usr/bin/'
        ;;
    ALSTOM*)
        alias p4='cd $PM4S_WORKING'
        alias pp4='cd $PARPM4S_WORKING'
        alias b4='cd $PM4S_BIN'
        alias bp4='cd $PARPM4S_BIN'
        alias r4='cd $PM4S_RTRT'
        alias t4='cd $PM4S_CHECKER'
        alias pu='cd $PUMA_WORKING'
        alias ru='cd $PUMA_RTRT'
        alias tu='cd $PUMA_CHECKER'
        alias po='cd $PUMAO2KC_WORKING'
        alias b='cd /cygdrive/d/Documents\ and\ Settings/100516805/Bureau'
        alias u='cd /cygdrive/d/Users/ctete/tools/'
        ;;
esac

#
##
### Emacs
# mode console
alias em='emacs -nw'
# mode graphique (win32)
alias ee='/cygdrive/d/cygwin/usr/bin/Emacs/emacs/bin/emacsclientw.exe -n'
# sudo
alias se='sudo emacs -nw'

#
##
### rm
# remember myMalloc :'(
alias rm='rm -i'

## Ancien reglage
## supprime les fichiers temporaires dans le dossiers courant
#alias ru='rm -rf *~'
#alias rf='rm -rf \#*'
#alias rd='rm -rf .*~'
#alias rg='rm -rf *\#'
#alias rr='ru || rf || rd || rg'

# supprime les fichiers temporaires dans le dossiers courant
alias rr='~/delete.temp.sh'

#
##
### navigateur
alias ie='firefox&' ## :D
alias op='opera&'
#alias f='firefox&'
alias gm='w3m -cookie https://mail.google.com/mail/u/0/?shva=1#inbox'

#
##
### script perso
# taille des plus gros dossiers en Ko/Mo
# option 'a' pour voir tous les fichiers
alias si='~/size.sh'

#
## recherche d'une chaine de caractere dans un fichier (grep)
## recherche recursive
#alias re='~/search.sh -r'  ## deprecated ##
#alias re='~/mysearch.sh -r'

# recherche sans prendre en compte la casse
alias rt='~/mysearch.sh -ri'
#
## recherche non recursive
#alias r='~/mysearch.sh -p'
#
# recherche sans filtrage sur dossier (ex. .svn out .git ...)
alias rj='~/mysearch.sh -jfr'

alias f='find -L . -type f -regextype posix-egrep'

##    ';|' signifie que apres le cas, on recherche une autre solution
##    ';;' signifie que apres le cas, on quitte le 'case'
case "$WORKING_ENVIRONMENT" in
    MAGNETI*)
        # copie fichier
        # copie de binaires
        alias cpy='~/copy.bin.sh'
        # copie des binaires et des sources pour NBNF_HL (nbnfhl)
        alias ch='~/copy.bin.sh -h'
        # copie des binaires et des sources pour NBNF_LL (nbnfll)
        alias cn='~/copy.bin.sh -n'
        # copie des binaires et des sources pour NSF_LL & NSF_HL (nsf)
        alias cs='~/copy.bin.sh -s'
        # copie des binaires et des sources pour ECAR (ensf)
        alias ce='~/copy.bin.sh -e'
        # copie des binaires et des sources pour XL1 (hybrid)
        alias cx='~/copy.bin.sh -x'
        # copie de sauvegarde de l'environnement
	alias b='~/backup.config.sh'
	;;
esac

#
## mise a jour du fichier TAGS
#alias mktag="ctags -e -L *.files"
#alias mktag="~/update.gtag.sh"
alias htags='htags -ahInsx --show-position --tree-view'

#
##
###    misc
# faineant
#alias b='bash'
# flag de compil (faineant)
alias g='gcc -Wall -W -Werror'

##    ';|' signifie que apres le cas, on recherche une autre solution
##    ';;' signifie que apres le cas, on quitte le 'case'
case "$WORKING_ENVIRONMENT" in
    #
    ## MAGNETI MARELLI
    MAGNETI*)
        alias m='ccm objectmake'
        # compil dans synergy (faineant)
	alias ccm='$SYNERGY_BIN/ccm.exe'
	alias ss='ccm start -d /project/TUPI -n tete -pw tet48cla -nogui'

        # copie le script pour partager nouvel version
        alias sy='cd /cygdrive/d/cygwin/usr/bin/AutoHotKey/scripts && /cygdrive/d/cygwin/usr/bin/AutoHotKey/Compiler/Ahk2Exe.exe /in synergy_mouse_wheel.ahk /out synergy_mouse_wheel.exe /icon synergy_mouse_wheel.ico && cp synergy_mouse_wheel.exe synergy_mouse_wheel/ && cp -f --preserve=all synergy_mouse_wheel.ahk synergy_mouse_wheel.help synergy_mouse_wheel.description synergy_mouse_wheel.ico README synergy_mouse_wheel/src/ && echo "\n### Update the README/ChangeLog/Version ###\n" && cd - > /dev/null'
        alias syy='cd /cygdrive/d/cygwin/usr/bin/AutoHotKey/scripts && zip -r synergy_mouse_wheel.zip synergy_mouse_wheel && cp synergy_mouse_wheel.zip /cygdrive/z/40_SOFTWARE/08_Tools/38_synergy_mouse_wheel && cp synergy_mouse_wheel.zip /cygdrive/z/40_SOFTWARE/99_Users/tete/tools/synergy_mouse_wheel && cp synergy_mouse_wheel.zip /cygdrive/z/06_PROJETS_EN_COURS/03_VAG/VW_CLUSTER_NSF_NBNF_2011/04_Software/97_Tools/synergy_mouse_wheel && cd - > /dev/null'

        # lance la compilation pour les projets NSF, NBNF_LL, NBNF_HL, ENSF...
        alias ms='cd $NSF_ROOT && ccm objectmake /CCM SEQ && cd - > /dev/null'
        alias ms0='cd $NSF_ROOT_2011 && ccm objectmake /CCM SEQ && cd - > /dev/null'
        alias mn='cd $NBNFLL_ROOT && ccm objectmake /CCM SEQ && cd - > /dev/null'
        alias mh='cd $NBNFHL_ROOT && ccm objectmake /CCM SEQ && cd - > /dev/null'
        alias mh0='cd $NBNFHL_ROOT_2011 && ccm objectmake /CCM SEQ && cd - > /dev/null'
        alias me='cd $ECAR_ROOT && ccm objectmake && cd - > /dev/null'
        alias mx='cd $XL1_ROOT && ccm objectmake && cd - > /dev/null'

        # lance la simulation visual studio pour les projets
        alias mss='cd $NSF_ROOT && ccm objectmake simul SIMUL_PROJECT=SIMUL_DISPLAY && cd - > /dev/null'
        alias msn='cd $NBNFLL_ROOT && ccm objectmake /CCM SEQ SIMUL=true SIMUL_PROJECT=SIMUL_DISPLAY && cd - > /dev/null'
        alias msh='cd $NBNFHL_ROOT && ccm objectmake /CCM SEQ SIMUL=true SIMUL_PROJECT=SIMUL_DISPLAY && cd - > /dev/null'
        alias mse='cd $ECAR_ROOT && ccm objectmake /CCM SEQ SIMUL=true SIMUL_PROJECT=SIMUL_DISPLAY && cd - > /dev/null'
        alias msx='cd $XL1_ROOT && ccm objectmake simul SIMUL_PROJECT=SIMUL_DISPLAY && cd - > /dev/null'

        # reproduit un make clean pour chaque projets
        alias mcs='cd $NSF_BIN && rm -rf ../out/compile/* ../out/include/* ../out/lib/* ../out/lst/* && cd - > /dev/null'
        alias mcs0='cd $NSF_BIN_2011 && rm -rf ../out/compile/* ../out/include/* ../out/lib/* ../out/lst/* && cd - > /dev/null'
        alias mcn='cd $NBNFLL_BIN && rm -rf ../out/compile/* ../out/include/* ../out/lib/* ../out/lst/* && cd - > /dev/null'
        alias mch='cd $NBNFHL_BIN && rm -rf ../out/compile/* ../out/include/* ../out/lib/* ../out/lst/* && cd - > /dev/null'
        alias mch0='cd $NBNFHL_BIN_2011 && rm -rf ../out/compile/* ../out/include/* ../out/lib/* ../out/lst/* && cd - > /dev/null'
        alias mce='cd $ECAR_BIN && rm -rf ../out/compile/* ../out/include/* ../out/lib/* ../out/lst/* && cd - > /dev/null'
        alias mcx='cd $XL1_BIN && rm -rf ../out/compile/* ../out/include/* ../out/lib/* ../out/lst/* && cd - > /dev/null'

        # polyspace pour chaque projet
        alias mph='cd $NBNFHL_ROOT && ccm objectmake /f polyspace /CCM SEQ'
        alias mpx='cd $XL1_ROOT && ccm objectmake /f polyspace /CCM SEQ'
        alias mps='cd $NSF_ROOT && ccm objectmake /f polyspace /CCM SEQ'

        # lance un rebuild all pour les projets NSF, NBNF_LL, NBNF_HL, ENSF et
        # XL1
        alias mrs='mcs && ms'
        alias mrs0='mcs0 && ms0'
        alias mrn='mcn && mn'
        alias mrh='mch && mh'
        alias mrh0='mch0 && mh0'
        alias mre='mce && me'
        alias mrx='mcx && mx'

        ## lancer un reconfigure avec show conflict dans n'importe quel projet
        alias ccmre="~/ccm.reconfigure.sh"

        ## lance un reconfigure et un show conflicts pour les 4 projets
        alias rs="cd $NSF_ROOT && ccmre -r && cd - > /dev/null"
        alias rs0="cd $NSF_ROOT_2011 && ccmre -r && cd - > /dev/null"
        alias rn="cd $NBNFLL_ROOT && ccmre -r && cd - > /dev/null"
        alias rh="cd $NBNFHL_ROOT && ccmre -r && cd - > /dev/null"
        alias rh0="cd $NBNFHL_ROOT_2011 && ccmre -r && cd - > /dev/null"
        alias re="cd $ECAR_ROOT && ccmre -r && cd - > /dev/null"
        alias rx="cd $XL1_ROOT && ccmre -r && cd - > /dev/null"

        alias rrt="~/ccm.read.and.review.sh"
        alias cct='echo " NAME          VERSION RELEASE TASK_RELEASE" && \
ccm query -u -f "%name %version %release %task_release" -task'
	;;

    ##
    ### ALSTOM Transport
    ALSTOM*)
        # shortcut to clearcase cli: cleartool
        alias ct="cleartool"
        alias cth="ct lshistory -graphical"

        # create file for gnu global to manage tag in emacs
        alias mktag='find . -type f -regex ".*\.\(h\|c\|cpp\)$" | grep -v "./include" > gtags.files && gtags -vf gtags.files'
        # run the "Checker" for PM4S project
        alias ch="cd $PM4S_CHECKER && 7z e -y $PM4S_CHECKER_BIN/scvr_check.zip && ./check_pm4s.bat && cat *.txt | grep -E (Module|Total) && rm -rf scvr_check.exe && cd - > /dev/null"
        # clean "Checker" folder for PM4S project
        alias rch="cd $PM4S_CHECKER && rm -rf report_*.txt && cd - > /dev/null"

        # clean "private" file from clearcase
        alias lp='ct lsprivate -other | sed "s/^\\\\/\/cygdrive\/z\//" | sed "s/\\\\/\//g" | grep -E '
        # makefile
        alias m='clearmake -v -C gnu -f'
        # makefile of PM4S project
        alias m4='cd $PM4S_WORKING/ && /cygdrive/d/Users/ctete/tools/strawberry-perl-5.14.2.1/perl/bin/perl.exe feu_pm4s.pl'
        # give information about a module/function/task
        alias pm='perl $PM4S_WORKING/module_fonction_SwRS.pl'
        # makefile of PUMA project
        alias mu='cd $PUMA_TEST_WORKING && python feu_puma.py'
        # makefile of ParPUMA project
        alias mpu='cd $PARPUMA_MAKE && clearmake -v -C gnu -f parametrisateur_gcc.mk'

        # show perl interface to link a clearcase element with a CR in clearquest
        alias cq="ct chevent -nc"
        # list all modified file between two releases (go to $PROJECT_BIN before)
        alias lsd='~/diffcr.sh'
        # remove all temporary file from QA-C
        alias rq='find . -type f -regex ".*\\.\\(i\\|met\\|err\\)$" | xargs rm -rf'
        ;;
esac

# ping google pour savoir si le net est dispo et si le dns fonctionne
alias pingg='ping -w 2 -c 1 google.com'
## avoir le diff en couleur
#alias diff='colordiff'
# lancer le configurateur des touches speciales dans un nouveau term
alias kb='zsh -f /usr/share/zsh/*/functions/zkbd'
# changer la config du clavier
alias kbfr="setxkbmap fr"
alias kbus="setxkbmap us"
# upload download in google code project
alias upgg='cd /cygdrive/d/Users/ctete/tmp/clt-dotemacs-read-only/ && svn up && perl ~/googlecodeupload.pl'
## grep color (en fait tres chiant quand plein de pipe)
#alias grep="grep --color=always"
# avoir un album en random
alias ra='~/random.album.sh'
