#!/bin/bash
## myscriptcolor.sh --- define bash color for other script

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
# Version: 1.1
# Created: June 2010
# Last-Updated: July 2010

# Change Log:
# 1.1 fix bug: white keep previous background color
# 1.0 add background
# 0.5 add gray
# 0.1 creation with all main colors

##  COLOR
# blanc
ColorFgWhiteBgBlack=[0\;37m[K
ColorFgWhiteBgGray=[40\;37m[K
ColorFgWhiteBgRed=[41\;37m[K
ColorFgWhiteBgYellow=[43\;37m[K
ColorFgWhiteBgGreen=[42\;37m[K
ColorFgWhiteBgCyan=[46\;37m[K
ColorFgWhiteBgBlue=[44\;37m[K
ColorFgWhiteBgMagenta=[45\;37m[K
# gris
ColorFgGrayBgBlack=[0\;30m[K
ColorFgGrayBgGray=[40\;30m[K        ## inutile ...
ColorFgGrayBgRed=[41\;30m[K
ColorFgGrayBgYellow=[43\;30m[K
ColorFgGrayBgGreen=[42\;30m[K
ColorFgGrayBgCyan=[46\;30m[K
ColorFgGrayBgBlue=[44\;30m[K
ColorFgGrayBgMagenta=[45\;30m[K
# rouge
ColorFgRedBgBlack=[0\;31m[K
ColorFgRedBgGray=[40\;31m[K
ColorFgRedBgRed=[41\;31m[K          ## inutile ...
ColorFgRedBgYellow=[43\;31m[K
ColorFgRedBgGreen=[42\;31m[K
ColorFgRedBgCyan=[46\;31m[K
ColorFgRedBgBlue=[44\;31m[K
ColorFgRedBgMagenta=[45\;31m[K
# jaune
ColorFgYellowBgBlack=[0\;33m[K
ColorFgYellowBgGray=[40\;33m[K
ColorFgYellowBgRed=[41\;33m[K
ColorFgYellowBgYellow=[43\;33m[K    ## inutile ...
ColorFgYellowBgGreen=[42\;33m[K
ColorFgYellowBgCyan=[46\;33m[K
ColorFgYellowBgBlue=[44\;33m[K
ColorFgYellowBgMagenta=[45\;33m[K
# vert
ColorFgGreenBgBlack=[0\;32m[K
ColorFgGreenBgGray=[40\;32m[K
ColorFgGreenBgRed=[41\;32m[K
ColorFgGreenBgYellow=[43\;32m[K
ColorFgGreenBgGreen=[42\;32m[K      ## inutile ...
ColorFgGreenBgCyan=[46\;32m[K
ColorFgGreenBgBlue=[44\;32m[K
ColorFgGreenBgMagenta=[45\;32m[K
# cyan (bleu ciel)
ColorFgCyanBgBlack=[0\;36m[K
ColorFgCyanBgGray=[40\;36m[K
ColorFgCyanBgRed=[41\;36m[K
ColorFgCyanBgYellow=[43\;36m[K
ColorFgCyanBgGreen=[42\;36m[K
ColorFgCyanBgCyan=[46\;36m[K        ## inutile ...
ColorFgCyanBgBlue=[44\;36m[K
ColorFgCyanBgMagenta=[45\;36m[K
# bleu
ColorFgBlueBgBlack=[0\;34m[K
ColorFgBlueBgGray=[40\;34m[K
ColorFgBlueBgRed=[41\;34m[K
ColorFgBlueBgYellow=[43\;34m[K
ColorFgBlueBgGreen=[42\;34m[K
ColorFgBlueBgCyan=[46\;34m[K
ColorFgBlueBgBlue=[44\;34m[K        ## inutile ...
ColorFgBlueBgMagenta=[45\;34m[K
# magenta
ColorFgMagentaBgBlack=[0\;35m[K
ColorFgMagentaBgGray=[40\;35m[K
ColorFgMagentaBgRed=[41\;35m[K
ColorFgMagentaBgYellow=[43\;35m[K
ColorFgMagentaBgGreen=[42\;35m[K
ColorFgMagentaBgCyan=[46\;35m[K
ColorFgMagentaBgBlue=[44\;35m[K
ColorFgMagentaBgMagenta=[45\;35m[K  ## inutile ...
# magenta
ColorFgTestBgTestBgBlack=[0\;31m[K
