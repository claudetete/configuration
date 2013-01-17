;;; MyShortcut.ahk --- add some shortcut for MS Windows to turn it in more
;;;                    user friendly work environment

;; Copyright (c) 2012 Claude Tete
;;
;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.
;;

;; Author: Claude Tete  <claude.tete@gmail.com>
;; Version: 1.3
;; Created: February 2011
;; Last-Updated: May 2012

;;; Commentary:
;;

;;; Change Log:
;; 2012-05-05 (1.3)
;;   add clearcase
;; 2012-XX-XX (1.2)
;;   remove concerning synergy&magneti
;; 2011-XX-XX (1.1)
;;   add shortcut for winmerge
;; 2011-XX-XX (1.0)
;;   fix some bug
;; 2011-02-24 (0.1)
;;   creation from scratch

;;; Code:
;;; ENVIRONMENT
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

Emacs24Path = D:\Users\ctete\tools\emacs-24.2\bin\
Emacs23Path = D:\Users\ctete\tools\emacs-23.4\bin\

;;; MENU
Menu, TRAY, Icon, MyShortcut.ico

;;   Can reload the script with Ctrl+Alt+R
^!#r:: Reload


;;
;;; PASTE
;;
#IfWinActive
:O:PM4S_::PM4S_CRT4_V1.4.0
:O:ct*::Claude TETE (ELSYS DESIGN)
#IfWinActive, ahk_class OpusApp
:O:i*::{{}-2147483648 to 2147483647{}}{Down}
:O:f*::{{}-3.4e38 to 3.4e38{}}{Down}
:O:c*::_real =>{{}-3.4e38 to 3.4e38{}}, _imag =>{{}-3.4e38 to 3.4e38{}}{Down}
:O:b*::{{}0 to 1{}}
::CE::
  SendInput CE_SI__1: {Left}{Left}{Left}{Left}
Return
::bo::boundary values:
#IfWinActive

;; remapping of CapsLock
;Capslock::Ctrl
;+Capslock::Capslock
SetCapsLockState, AlwaysOff

;; map Alt+Capslock to backward in Alt+TAB
;LAlt & Capslock::ShiftAltTab
;LAlt & Tab::AltTab

;; EMACS SHORTCUTS
;; ` or ²
#SC029::
  Run, %Emacs23Path%emacsclientw.exe --no-wait --alternate-editor="%Emacs23Path%runemacs.exe" ""
Return
;; 1 or &
#SC002::
  Run, %Emacs24Path%emacsclientw.exe --no-wait --alternate-editor="%Emacs24Path%runemacs.exe" ""
return



;;
;; WINDOWS TASKBAR
;;
#If MouseIsOver("ahk_class Shell_TrayWnd")
~WheelUp::Send #+^{Left}

#If MouseIsOver("ahk_class Shell_TrayWnd")
~WheelDown::Send #+^{Right}

#If MouseIsOver("ahk_class Shell_TrayWnd")
~MButton::Send #{<}


;; Windows Switch with Mouse Wheel and Middle Button
;~MButton & WheelDown::AltTab
;~MButton & WheelUp::ShiftAltTab

;;
;; VBA EDITOR
;;
;#IfWinActive, ahk_class TFormViewUV.UnicodeClass
;~WheelDown::PgDn

;#IfWinActive, ahk_class TFormViewUV.UnicodeClass
;~WheelUp::PgUp

;~RButton & MButton::Send {Control Alt LWin MButton}

;;
;; WINMERGE
;;
#IfWinActive, ahk_class WinMergeWindowClassW
^F12::
  ;; open preference window
  SendInput, !e
  SendInput, p
  Sleep, 50

  ;; get focus on list and Comparaison
  SendInput {Tab}
  Sleep, 50
  SendInput {Tab}
  Sleep, 50
  SendInput {Tab}
  Sleep, 200
  SendInput {Home}
  Sleep, 200
  SendInput {Down}
  Sleep, 50

  ;; set compare all space
  SendInput, !o
  Sleep, 50
  SendInput, {Enter}
Return

#IfWinActive, ahk_class WinMergeWindowClassW
^F11::
  ;; open preference window
  SendInput, !e
  SendInput, p
  Sleep, 50

  ;; get focus on list and Comparaison
  SendInput {Tab}
  Sleep, 50
  SendInput {Tab}
  Sleep, 50
  SendInput {Tab}
  Sleep, 200
  SendInput {Home}
  Sleep, 200
  SendInput {Down}
  Sleep, 50

  ;; set compare no space
  SendInput, !t
  Sleep, 50
  SendInput, {Enter}
Return

#IfWinActive, ahk_class WinMergeWindowClassW
^F10::
  ;; merge
  SendInput, !{Down}
  SendInput, !{Right}
  Sleep, 50
Return

#IfWinActive, ahk_class WinMergeWindowClassW
!WheelDown::SendInput, !{Down}

#IfWinActive, ahk_class WinMergeWindowClassW
!WheelUp::SendInput, !{Up}

#IfWinActive, ahk_class WinMergeWindowClassW
~XButton1 & WheelDown::Send, !{Down}

#IfWinActive, ahk_class WinMergeWindowClassW
~XButton1 & WheelUp::Send, !{Up}

;#IfWinActive, ahk_class WinMergeWindowClassW
;XButton1::Alt

;;
;; MS WORD
;;
#IfWinActive, ahk_class OpusApp
;; back
XButton1::!Left
;; next
XButton2::!Right
;; Ctrl+Click
MButton::^LButton
;; tmp
;!SC029::
;  MouseGetPos, X, Y
;  MouseMove, 1050, 85, 0
;  MouseClick
;  MouseMove, %X%, %Y%, 0
;Return

;;
;; MS EXCEL
;;
#IfWinActive,ahk_class XLMAIN
;; back
XButton1::!Left
;; next
XButton2::!Right


;; handler for hotkey
MouseIsOver(WinTitle) {
    MouseGetPos,,, Win
    return WinExist(WinTitle . " ahk_id " . Win)
}


;;
;; BEYOND COMPARE
;;
;; move with mouse to diff to diff
#IfWinActive, ahk_class TViewForm.UnicodeClass
#WheelDown::Send, ^{n}

#IfWinActive, ahk_class TViewForm.UnicodeClass
#WheelUp::Send, ^{p}


;;; CLEARCASE
;;
;; CHECKIN/CHECKOUT (clearcase clearquest perl)
;;
#IfWinActive checkin Z
Enter::CheckInOrOutOK()
NumpadEnter::CheckInOrOutOK()

#IfWinActive checkin z
Enter::CheckInOrOutOK()
NumpadEnter::CheckInOrOutOK()

#IfWinActive checkin M
Enter::CheckInOrOutOK()
NumpadEnter::CheckInOrOutOK()

#IfWinActive checkin m
Enter::CheckInOrOutOK()
NumpadEnter::CheckInOrOutOK()

#IfWinActive checkout M
Enter::CheckInOrOutOK()
NumpadEnter::CheckInOrOutOK()

#IfWinActive checkout m
Enter::CheckInOrOutOK()
NumpadEnter::CheckInOrOutOK()

#IfWinActive checkout Z
Enter::CheckInOrOutOK()
NumpadEnter::CheckInOrOutOK()

#IfWinActive checkout z
Enter::CheckInOrOutOK()
NumpadEnter::CheckInOrOutOK()

CheckInOrOutOK()
{
  MouseGetPos, X, Y
  MouseMove, 510, 42, 0
  MouseClick
  MouseMove, %X%, %Y%, 0
}
