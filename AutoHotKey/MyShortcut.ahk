;;; MyShortcut.ahk --- add some shortcut for MS Windows to turn it in more
;;;                    user friendly work environment

;; Copyright (c) 2011-2013 Claude Tete
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
;; Version: 1.4
;; Created: February 2011
;; Last-Updated: February 2013

;;; Commentary:
;;

;;; Change Log:
;; 2013-02-04 (1.4)
;;   add ms explorer alternative copy and all clavier+ shortcuts
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
Emacs23Path = D:\Users\ctete\tools\emacs-24.3\bin\

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

;; handler for hotkey
MouseIsOver(WinTitle) {
    MouseGetPos,,, Win
    return WinExist(WinTitle . " ahk_id " . Win)
}


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

;;
;;; MS EXPLORER
;;
;; copy path and filename
SetTitleMatchMode, Regex
#IfWinActive, ahk_class Progman|WorkerW|CabinetWClass|ExploreWClass|#32770
;; copy all path
^+c::
  clipboard := GetExplorerFilePath()
Return
;; copy only filename with extension
^!c::
  clipboard := GetExplorerFilePath()
  SplitPath, clipboard, name
  clipboard = %name%
Return
;; copy only path without filename
^!+c::
  clipboard := GetExplorerFilePath()
  SplitPath, clipboard, , dir
  clipboard = %dir%
Return
SetTitleMatchMode, 1
;; get the file path from selected file
GetExplorerFilePath()
{
  SetTitleMatchMode, Regex
  ControlGetText myCurrentPath, Edit1, ahk_class Progman|WorkerW|CabinetWClass|ExploreWClass|#32770
  file := GetExplorerSelectedFile()
  file := myCurrentPath . "\" . file

  Return file
}
;;; get the selected file path
GetExplorerSelectedFile()
{
   global SoftwareName

   ;; init filename
   file = ""
   ;; get all selected file
   ControlGet, selectedFiles, List, Selected Col1, SysListView321, %WindowName%
   Loop, Parse, selectedFiles, `n  ; Rows are delimited by linefeeds (`n).
   {
     If (A_Index = 1)
     {
       file := A_LoopField
     }
     Else
     {
       ; Indicate that several files are selected, we return only the first one
       ErrorLevel := A_Index
     }
   }

   if file = ""
   {
      MsgBox, 0x10, %SoftwareName%: error, Error: You must select a file.
      return ""
   }

   Return file
}

;;
;;; CMD
;;
;; copy paste shortcuts (from jixiuf at GitHub)
#IfWinActive ahk_class ConsoleWindowClass
^v::StringTypePaste(Clipboard)
^y::StringTypePaste(Clipboard)
#Esc::Send ,exit`n
#IfWinActive
StringTypePaste(p_str, p_condensenewlines=1)
{
  if (p_condensenewlines)
  {
    p_str:=RegExReplace(p_str, "[`r`n]+", "`n")
  }
  Send, % "{Raw}" p_str
}

;;
;;; MISC SHORTCUTS
;;
;; non azerty character
#é::É
#è::È
#ç::Ç
#=::SendInput, {U+2260} ; not equal
;; SC033 = ; (see key history in ahk)
#SC033::SendInput, {U+2264} ; inf or equal
;; SC034 = :
#SC034::SendInput, {U+2265} ; up or equal

;; (Win+N) run at start
#n::
  ;; virtual desktop on MS Windows
  Run, D:/Users/ctete/tools/VirtuaWin/VirtuaWin.exe
  ;; mouse gesture everywhere
  Run, D:/Users/ctete/tools/StrokeIt/strokeit.exe
  ;; outlook
  Run, C:/Program Files/Microsoft Office/Office14/OUTLOOK.EXE
  ;; clearcase explorer
  Run, clearexplorer.exe
  ;; enable symbol link under MS Windows XP
  Run, D:/Users/ctete/tools/symlink-1.06-x86/senable.exe, D:/Users/ctete/tools/symlink-1.06-x86
  ;; Use the mouse wheel on unfocus window like in linux
  Run, D:/Users/ctete/tools/AutoHotKey/scripts/WinUnfocusMouseWheel.ahk
  ;; have the mouse wheel working in clearquest
  Run, D:/Users/ctete/tools/AutoHotKey/scripts/clearquest_mouse_wheel/clearquest_mouse_wheel.ahk, D:/Users/ctete/tools/AutoHotKey/scripts/clearquest_mouse_wheel
  ;; tilda like for ms windows
  Run, D:/Users/ctete/tools/AutoHotKey/scripts/QuahkeConsole.ahk
  ;; increase number of repeat key
  Run, D:/Users/ctete/tools/AutoHotKey/scripts/FastNavKeys.ahk
  ;; move/resize like in KDE
  Run, D:/Users/ctete/tools/AutoHotKey/scripts/KDE Mover-Sizer for Windows/KDE Mover-Sizer.exe, D:/Users/ctete/tools/AutoHotKey/scripts/KDE Mover-Sizer for Windows
  ;; nice/quick menu anywhere to have shortcuts to all favorite folder
  Run, D:/Users/ctete/tools/FolderMenu/FolderMenu.exe, D:/Users/ctete/tools/FolderMenu
  ;; advanced clipboard
  Run, D:/Users/ctete/tools/Framakey/Apps/DittoPortable/DittoPortable.exe
  ;; make clearcase shortcut available everwhere
  Run, D:/Users/ctete/tools/AutoHotKey/scripts/ClearCaseShortcut.ahk
  ;; time tracking to be easy the weelky/monthly report
  Run, D:/Users/ctete/PM4S/doc/rapport_hebdomadaire/TimeTracking_ctete.xlsx
  ;; reload this script to overload all shortcut from other scripts
  Reload
Return
;; (Win+A) run software
#a::Run, D:/Users/ctete/tools/OperaPortable/OperaPortable.exe
;; (Win+Q) run calculator
#q::Run, calc.exe
;; (Win+S) run clearcase explorer
#s::Run, clearexplorer.exe
;; (Win+W) run cleerquest
#w::Run, clearquest.exe
;; (Win+X) run process explorer
#x::Run, D:/Users/ctete/tools/ProcessExplorer/procexp.exe
;; (Win+Z) run cubic explorer
#z::Run, D:/Users/ctete/tools/CubicExplorer/CubicExplorer.exe

;;  kill properties windows of clearcase
#IfWinActive, ahk_exe cleardescribe.exe
Escape::SendInput !{F4}
#IfWinActive

;; emacs
#IfWinActive, ahk_exe emacs.exe
;; re macro
Pause::SendInput ^xe
#IfWinActive

;; PDF-XChange Viewer
#IfWinActive, ahk_exe pdfxcview.exe
;; outils zoom
^!f8::SendInput !ozl
;; outils selection
^!f9::SendInput !obs
;; outils main
^!f10::SendInput !obm
#IfWinActive

;; RTRT Studio
#IfWinActive, ahk_exe studio.exe
;; export in html
Pause::
  SendInput !fe
  Sleep, 100
  SendInput {Enter}
  Sleep, 100
  SendInput {Enter}
Return
;; close current tab
^w::SendInput !fc
#IfWinActive

;; excel
#IfWinActive, ahk_exe excel.exe
;; back
XButton1::!Left
;; next
XButton2::!Right
;; easy shortcut one shot with pause
Pause::SendInput {Tab}{Tab}{Tab}{Down}{Home}
;; insert file
f4::
  SendInput !sj
  Sleep 300
  SendInput !{Tab}
  Sleep 100
  SendInput !P
  Sleep 500
  SendInput +{Tab}{down}
Return
;; multiple up
CtrlBreak::SendInput {Up}{Up}{Up}{Up}{Up}{Up}{Up}{Up}{Up}{Up}{Up}
;; paste with options
+Insert::^!v
;; search
f3::SendInput +{f4}
#IfWinActive

;; word
#IfWinActive, ahk_exe WINWORD.EXE
;; back
XButton1::!Left
;; next
XButton2::!Right
;; Ctrl+Click
MButton::^LButton
!SC029:: ;; ² or `
  ;; zoom to 84%
  SendInput !nw
  Sleep, 100
  SendInput !e84
  Sleep, 100
  SendInput {Enter}
Return
!SC002:: ;; azerty & or 1
  ;; show/hide comments
  SendInput !ra{Down}{Enter}
Return
!SC003:: ;; azerty é or 2
  ;; show/hide all characters
  SendInput ^+_
Return
!SC004:: ;; azerty " or 3
  ;; show/hide style pane
  SendInput ^!+s
Return
!SC005:: ;; azerty ' or 4
  ;; show/hide tree
  SendInput ^!$
Return
;; delete word
!d::^Del
;; search
f3::SendInput +{f4}
;; easy shortcut
Pause::SendInput {End}+{Home}^v{Down}{Down}{Down}{Down}
#IfWinActive
