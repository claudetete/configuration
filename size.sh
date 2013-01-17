#! /bin/bash
# size.sh --- script to display a file list in human readable size

# Copyright (c) 2006-2008 Claude Tete
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
# Version: 1.0
# Created: February 2008
# Last-Updated: December 2006

# Change Log:
# 1.0 add parameter in call ('a' to take all files)
# 0.5 correction of bugs + only take file with big size
# 0.1 creation from scratch functionnal with bugs

#    couleur
source ~/myscriptcolor.sh

# compteur (nombre de ligne a virer au debut)
i=3

filepathls=/tmp/size.ls.$RANDOM
ls -la > $filepathls

filepathls1=/tmp/size.ls1.$RANDOM
ls -a1 > $filepathls1

nb=$(cat $filepathls | wc -l)

filepathdu=/tmp/size.du.$RANDOM

ShowSomething=FALSE

# commentaire
echo -n $ColorFgRedBgBlack
echo -n "### pour les fichiers essaye un petit $ColorFgGreenBgBlack\"lc\"$ColorFgRedBgBlack alors, heureuse ?"
echo $ColorFgWhiteBgBlack
echo

if [ $# == 0 ]; then

    echo -n $ColorFgCyanBgBlack
    echo -n "SIZE    FOLDER:"
    echo $ColorFgWhiteBgBlack

    while [ $i != $nb ]; do

	t=$(cat $filepathls1 | head -n $i | tail -1)
	t=$(echo $t | sed "s/ /\\ /g")

	s=$(cat $filepathls | head -n $(($i + 1)) | tail -1 | cut -b 1)

	du -sk "$t" > $filepathdu

	if [ $s == 'd' ]; then
	    if [ $(cat $filepathdu | cut -c 2) ]; then
		if [ $(cat $filepathdu | cut -c 3) ]; then
		    cat $filepathdu
                          ShowSomething=TRUE
		fi
	    fi
	fi
	i=$(($i + 1))
    done
fi

if [ $# == 1 ]; then
    if [ $1 == 'a' ]; then
	while [ $i != $nb ]; do
	    t=$(cat $filepathls1 | head -n $i | tail -1)

	    du -sk "$t" > $filepathdu
	    cat $filepathdu
	    i=$(($i + 1))
	done
    fi
fi

if [ $ShowSomething == FALSE ]; then
    echo -n $ColorFgBlueBgBlack
    echo -n "error: nothing is too big"
    echo $ColorFgWhiteBgBlack
fi

echo -n $ColorFgGreenBgBlack
echo -n "       by Claude TETE"
echo $ColorFgWhiteBgBlack
