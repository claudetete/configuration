;;; ClearCaseShortcut.ahk --- New Shortcuts for ClearCase

;; Copyright (c) 2012-2013 Claude Tete
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
;; Version: 1.5
;; Created: February 2012
;; Last-Updated: February 2013

;;; Commentary:
;;
;; TODO: cannot get file path from tree version window ?

;;; Change Log:
;; 2013-02-04 (1.5)
;;   add emacs + use regex for windows explorer title + fix bug when change main
;;   shortcut
;; 2013-01-11 (1.4)
;;    remove clearcase path bin, use PATH variable
;; 2013-01-09 (1.3)
;;    add parameter to give a specific ini file + add cancel button
;; 2013-01-07 (1.2)
;;    can set shortcut and other settings in ini file + clean up + add new
;;    compatible window
;; 2012-12-20 (1.1)
;;    coherent shortcuts between different window
;; 2012-03-20 (1.0)
;;     add just one shortcut + resize properties
;; 2012-02-28 (0.1)
;;     creation from scratch

;;; Code:
;; Recommended for performance and compatibility with future AutoHotkey releases.
#NoEnv
;; Recommended for catching common errors. (only since AutoHotKey 1.1.7.0)
;; can be removed
#Warn
;; Recommended for new scripts due to its superior speed and reliability.
SendMode Input
;; Ensures a consistent starting directory.
SetWorkingDir %A_ScriptDir%
;; only on instance of this script
#SingleInstance force

;
;;
;;; SETTINGS
;; name of script
SoftwareName = ClearCaseShortcut
;; version of script
SoftwareVersion = 1.5

;
;;
;;; PARAMETERS
if 0 > 0
{
  ;; get first parameter
  IniFilePath = %1%
  ;; when file exist
  IfExist, IniFilePath
  {
    ;; get long path instead of short path
    Loop %IniFilePath%, 1
      IniFile = %A_LoopFileLongPath%
  }
  else
  {
    ;; file do not exist
    IniFile = %IniFilePath%
  }
}
else
{
  ;; no parameter
  IniFile = %SoftwareName%.ini
}

;
;;
;;; READ INI FILE
GoSub, LoadIniFile

;
;;
;;; MAIN SHORTCUT
;; init prefix hotkey
;; regex title match
SetTitleMatchMode, Regex
Hotkey, IfWinActive, %ExplorerTitle%
HotKey, %MainShortcut%, CheckShortcutExplorer
;; normal title match
SetTitleMatchMode, 1
Hotkey, IfWinActive, %ClearCaseFindCheckoutTitle%
Hotkey, %MainShortcut%, CheckShortcutFindCheckout
Hotkey, IfWinActive, %ClearCaseHistoryTitle%
Hotkey, %MainShortcut%, CheckShortcutHistory
Hotkey, IfWinActive, %ClearCaseExplorerTitle%
Hotkey, %MainShortcut%, CheckShortcutClearCaseExplorer
Hotkey, IfWinActive, %ClearCaseTreeVersionTitle%
Hotkey, %MainShortcut%, CheckShortcutTreeVersion
Hotkey, IfWinActive, %UltraEditTitle%
Hotkey, %MainShortcut%, CheckShortcutUltraEdit
Hotkey, IfWinActive, %EmacsTitle%
Hotkey, %MainShortcut%, CheckShortcutEmacs
Hotkey, IfWinActive

;
;;
;;; MENU
Menu, TRAY, Icon, clearexplorer.exe
;; Delete the current menu
Menu, tray, NoStandard
;; Add the item About in the menu
Menu, tray, add, About, MenuAbout
;; Add the item Help in the menu
Menu, tray, add, Help, MenuHelp
;; Creates a separator line.
Menu, tray, add
;; Add the item Shortcuts in the menu
Menu, tray, add, Options, MenuOptions
;; Add the item Reload in the menu
Menu, tray, add, Reload .ini file, MenuReload
;; Add the item Edit ini in the menu
Menu, tray, add, Edit .ini file, MenuEditIni
;; Add the item Create/Save ini in the menu
Menu, tray, add, Create/Save .ini file, MenuCreateSaveIni
;; Creates a separator line.
Menu, tray, add
;; add the standard menu
Menu, tray, Standard


;; End of script
return

;
;;
;;; EXPLORER
;===============================================================================
;;
;;; sub function to call function with parameter only for explorer
CheckShortcutExplorer:
  CheckShortcutExplorer(ExplorerTitle)
Return

;;
;;; capture next key and execute associated function
CheckShortcutExplorer(WindowName)
{
  global CheckOutShortcut, CheckInShortcut, UnCheckOutShortcut, HistoryShortcut, ComparePrevShortcut
  global TreeVersionShortcut, ExplorerShortcut, FindCheckoutShortcut, ElementPropertiesShortcut
  global VersionPropertiesShortcut

  ;; capture next key
  Input, MyKey, L1 T2, {Escape}
  ;; when timeout quit
  if ErrorLevel = Timeout
    return
  ;; when CheckOutShortcut Checkout
  if MyKey = %CheckOutShortcut%
  {
    file := GetExplorerFilePath(WindowName)
    CCCheckout(file)
  }
  ;; when CheckInShortcut -> Checkin
  else if MyKey = %CheckInShortcut%
  {
    file := GetExplorerFilePath(WindowName)
    CCCheckin(file)
  }
  ;; when UnCheckOutShortcut -> Uncheckout
  else if MyKey = %UnCheckOutShortcut%
  {
    file := GetExplorerFilePath(WindowName)
    CCUncheckout(file)
  }
  ;; when HistoryShortcut -> History
  else if MyKey = %HistoryShortcut%
  {
    file := GetExplorerFilePath(WindowName)
    CCHistory(file)
  }
  ;; when ComparePrevShortcut -> Diff
  else if MyKey = %ComparePrevShortcut%
  {
    file := GetExplorerFilePath(WindowName)
    CCDiff(file)
  }
  ;; when TreeVersionShortcut -> Tree Version
  else if MyKey = %TreeVersionShortcut%
  {
    file := GetExplorerFilePath(WindowName)
    CCTreeVersion(file)
  }
  ;; when ExplorerShortcut -> ClearCase Explorer
  else if MyKey = %ExplorerShortcut%
  {
    dir := GetExplorerDirPath(WindowName)
    CCExplorer(dir)
  }
  ;; when FindCheckoutShortcut -> Find Checkout
  else if MyKey = %FindCheckoutShortcut%
  {
    dir := GetExplorerDirPath(WindowName)
    CCFindCheckout(dir)
  }
  ;; when ElementPropertiesShortcut -> Element Properties
  else if MyKey = %ElementPropertiesShortcut%
  {
    file := GetExplorerFilePath(WindowName)
    CCElementProperties(file)
  }
  ;; when VersionPropertiesShortcut -> Version Properties
  else if MyKey = %VersionPropertiesShortcut%
  {
    file := GetExplorerFilePath(WindowName)
    CCVersionProperties(file)
  }
  ;; other characters are not considered
}
Return

;;
;;; get the selected file
GetExplorerFilePath(WindowName)
{
  SetTitleMatchMode, Regex
  ControlGetText myCurrentPath, Edit1, %WindowName%
  file := GetExplorerSelectedFile(WindowName)
  file := myCurrentPath . "\" . file
  SetTitleMatchMode, 1

  Return file
}

;;
;;; get the current directory
GetExplorerDirPath(WindowName)
{
  file := GetExplorerFilePath(WindowName)
  SplitPath, file, , dir

  Return dir
}

;;
;;; get the selected file path
GetExplorerSelectedFile(WindowName)
{
   global SoftwareName

   ;; init filename
   file = ""
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

;
;;
;;; HISTORY BROWSER
;===============================================================================
;;
;;; sub function to call function (needed to not define global variable)
CheckShortcutHistory:
  CheckShortcutHistoryFunction()
Return
;;
;;; check shortcut after prefix and run associated function
CheckShortcutHistoryFunction()
{
  global CheckOutShortcut, CheckInShortcut, UnCheckOutShortcut, HistoryShortcut, ComparePrevShortcut
  global TreeVersionShortcut, ExplorerShortcut, FindCheckoutShortcut, ElementPropertiesShortcut
  global VersionPropertiesShortcut, ClearCaseHistoryTitle

  ;; capture next key
  Input, MyKey, L1 T2, {Escape}
  ;; when timeout quit
  if ErrorLevel = Timeout
    return
  ;; when CheckOutShortcut -> Checkout
  if MyKey = %CheckOutShortcut%
  {
    file := GetHistoryFile()
    CCCheckout(file)
  }
  ;; when CheckInShortcut -> Checkin
  else if MyKey = %CheckInShortcut%
  {
    file := GetHistoryFile()
    CCCheckin(file)
  }
  ;; when UnCheckOutShortcut -> Uncheckout
  else if MyKey = %UnCheckOutShortcut%
  {
    file := GetHistoryFile()
    CCUncheckout(file)
  }
  ;; when HistoryShortcut -> History
  else if MyKey = %HistoryShortcut%
  {
    file := GetHistoryFile()
    CCHistory(file)
  }
  ;; when ComparePrevShortcut -> Diff
  else if MyKey = %ComparePrevShortcut%
    WinMenuSelectItem, %ClearCaseHistoryTitle%, , Tools, Compare with Previous Version
  ;; when TreeVersionShortcut -> Tree Version
  else if MyKey = %TreeVersionShortcut%
    WinMenuSelectItem, %ClearCaseHistoryTitle%, , Tools, Version Tree
  ;; when ExplorerShortcut -> ClearCase Explorer
  else if MyKey = %ExplorerShortcut%
  {
    dir := GetHistoryDir()
    CCExplorer(dir)
  }
  ;; when FindCheckoutShortcut -> Find Checkout
  else if MyKey = %FindCheckoutShortcut%
  {
    dir := GetHistoryDir()
    CCFindCheckout(dir)
  }
  ;; when ElementPropertiesShortcut -> Element Properties
  else if MyKey = %ElementPropertiesShortcut%
  {
    file := GetHistoryFile()
    CCElementProperties(file)
  }
  ;; when VersionPropertiesShortcut -> Version Properties
  else if MyKey = %VersionPropertiesShortcut%
    WinMenuSelectItem, %ClearCaseHistoryTitle%, , Tools, Properties
  ;; other characters are not considered
}
Return

;;
;;; get the file from history browser
GetHistoryFile()
{
  global ClearCaseHistoryTitle

  WinTitle := RegExReplace(ClearCaseHistoryTitle, "(.*) ahk_exe.*", "$1")
  WinGetTitle, myTitle, %ClearCaseHistoryTitle%
  StringReplace, filePath, myTitle, %WinTitle%
  StringTrimLeft, filePath, filePath, 1

  Return filePath
}

;;
;;; get the dir from history browser
GetHistoryDir()
{
  filePath := GetHistoryFile()
  SplitPath, filePath, , dirPath

  Return dirPath
}

;
;;
;;; FIND CHECKOUT
;===============================================================================
;;
;;; sub function to call function (needed to not define global variable)
CheckShortcutFindCheckout:
  CheckShortcutFindCheckoutFunction()
Return
;;
;;; after main shortcut check second bind during 2s and run functions
CheckShortcutFindCheckoutFunction()
{
  global CheckOutShortcut, CheckInShortcut, UnCheckOutShortcut, HistoryShortcut, ComparePrevShortcut
  global TreeVersionShortcut, ExplorerShortcut, FindCheckoutShortcut, ElementPropertiesShortcut
  global VersionPropertiesShortcut, ClearCaseFindCheckoutTitle

  ;; capture next key (T2 = timeout 2s, L1 = one character)
  Input, MyKey, L1 T2, {Escape}
  ;; when timeout quit
  if ErrorLevel = Timeout
    return
  ;; when CheckOutShortcut -> Checkout
  if MyKey = %CheckOutShortcut%
  {
    file := GetFinCheckoutsSelectedFile()
    CCCheckout(file)
  }
  ;; when CheckInShortcut -> Checkin
  else if MyKey = %CheckInShortcut%
    WinMenuSelectItem, %ClearCaseFindCheckoutTitle%, , Tools, Check In...
  ;; when UnCheckOutShortcut -> Uncheckout
  else if MyKey = %UnCheckOutShortcut%
    WinMenuSelectItem, %ClearCaseFindCheckoutTitle%, , Tools, Undo Checkout...
  ;; when HistoryShortcut -> History
  else if MyKey = %HistoryShortcut%
    WinMenuSelectItem, %ClearCaseFindCheckoutTitle%, , Tools, History
  ;; when ComparePrevShortcut -> Diff
  else if MyKey = %ComparePrevShortcut%
    WinMenuSelectItem, %ClearCaseFindCheckoutTitle%, , Tools, Compare with Previous Version
  ;; when TreeVersionShortcut -> Tree Version
  else if MyKey = %TreeVersionShortcut%
    WinMenuSelectItem, %ClearCaseFindCheckoutTitle%, , Tools, Version Tree
  ;; when ExplorerShortcut -> ClearCase Explorer
  else if MyKey = %ExplorerShortcut%
  {
    dir := GetFindCheckoutsDir()
    CCExplorer(dir)
  }
  ;; when FindCheckoutShortcut -> Find Checkout
  else if MyKey = %FindCheckoutShortcut%
  {
    dir := GetFindCheckoutsDir()
    CCFindCheckout(dir)
  }
  ;; when ElementPropertiesShortcut -> Element Properties
  else if MyKey = %ElementPropertiesShortcut%
  {
    file := GetFinCheckoutsSelectedFile()
    CCElementProperties(file)
  }
  ;; when VersionPropertiesShortcut -> Version Properties
  else if MyKey = %VersionPropertiesShortcut%
    WinMenuSelectItem, %ClearCaseFindCheckoutTitle%, , Tools, Properties
  ;; other characters are not considered
}
Return

;;
;;; get the selected file path (surprising it's the same list than MS Explorer)
GetFinCheckoutsSelectedFile()
{
   global ClearCaseFindCheckoutTitle, SoftwareName

   ;; init filename
   file = ""
   ControlGet, selectedFiles, List, Selected Col1, SysListView321, %ClearCaseFindCheckoutTitle%
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
;;; get the dir from find checkouts
GetFindCheckoutsDir()
{
  filePath := GetFinCheckoutsSelectedFile()
  SplitPath, filePath, , dirPath

  Return dirPath
}

;
;;
;;; CLEARCASE EXPLORER
;===============================================================================
;;
;;; sub function to call function (needed to not define global variable)
CheckShortcutClearCaseExplorer:
  CheckShortcutClearCaseExplorerFunction()
Return
;;
;;; after main shortcut check second bind during 2s and run functions
CheckShortcutClearCaseExplorerFunction()
{
  global CheckOutShortcut, CheckInShortcut, UnCheckOutShortcut, HistoryShortcut, ComparePrevShortcut
  global TreeVersionShortcut, ExplorerShortcut, FindCheckoutShortcut, ElementPropertiesShortcut
  global VersionPropertiesShortcut, ClearCaseExplorerTitle

  ;; capture next key
  Input, MyKey, L1 T2, {Escape}
  ;; when timeout quit
  if ErrorLevel = Timeout
    return
  ;; when CheckOutShortcut -> Checkout
  if MyKey = %CheckOutShortcut%
  {
    ;; WinMenuSelectItem cannot be used with clearcase explorer like outlook, etc
    ;; Send message WM_COMMAND (0x111) to the clearcase explorer window
    ;; with 0x8004 wParam and 0 lParam (checkout in menu)
    PostMessage, 0x111, 32772, 0, , %ClearCaseExplorerTitle%
  }
  ;; when CheckInShortcut -> Checkin
  else if MyKey = %CheckInShortcut%
  {
    ;; WinMenuSelectItem cannot be used with clearcase explorer like outlook, etc
    ;; Send message WM_COMMAND (0x111) to the clearcase explorer window
    ;; with 0x8005 wParam and 0 lParam (checkin in menu)
    PostMessage, 0x111, 32773, 0, , %ClearCaseExplorerTitle%
  }
  ;; when UnCheckOutShortcut -> Uncheckout
  else if MyKey = %UnCheckOutShortcut%
  {
    ;; WinMenuSelectItem cannot be used with clearcase explorer like outlook, etc
    ;; Send message WM_COMMAND (0x111) to the clearcase explorer window
    ;; with 0x8011 wParam and 0 lParam (undo checkout in menu)
    PostMessage, 0x111, 32785, 0, , %ClearCaseExplorerTitle%
  }
  ;; when HistoryShortcut -> History
  else if MyKey = %HistoryShortcut%
  {
    ;; WinMenuSelectItem cannot be used with clearcase explorer like outlook, etc
    ;; Send message WM_COMMAND (0x111) to the clearcase explorer window
    ;; with 0x8017 wParam and 0 lParam (history in menu)
    PostMessage, 0x111, 32791, 0, , %ClearCaseExplorerTitle%
  }
  ;; when ComparePrevShortcut -> Diff
  else if MyKey = %ComparePrevShortcut%
  {
    ;; WinMenuSelectItem cannot be used with clearcase explorer like outlook, etc
    ;; Send message WM_COMMAND (0x111) to the clearcase explorer window
    ;; with 0x8012 wParam and 0 lParam (compare with previous in menu)
    PostMessage, 0x111, 32786, 0, , %ClearCaseExplorerTitle%
  }
  ;; when TreeVersionShortcut -> Tree Version
  else if MyKey = %TreeVersionShortcut%
  {
    ;; WinMenuSelectItem cannot be used with clearcase explorer like outlook, etc
    ;; Send message WM_COMMAND (0x111) to the clearcase explorer window
    ;; with 0x8013 wParam and 0 lParam (version tree in menu)
    PostMessage, 0x111, 32787, 0, , %ClearCaseExplorerTitle%
  }
  ;; when ExplorerShortcut -> ClearCase Explorer
  else if MyKey = %ExplorerShortcut%
  {
    dir := GetClearCaseExplorerDir()
    CCExplorer(dir)
  }
  ;; when FindCheckoutShortcut -> Find Checkout
  else if MyKey = %FindCheckoutShortcut%
  {
    dir := GetClearCaseExplorerDir()
    CCFindCheckout(dir)
  }
  ;; when ElementPropertiesShortcut -> Element Properties
  else if MyKey = %ElementPropertiesShortcut%
  {
    ;; WinMenuSelectItem cannot be used with clearcase explorer like outlook, etc
    ;; Send message WM_COMMAND (0x111) to the clearcase explorer window
    ;; with 0x8070 wParam and 0 lParam (element properties in menu)
    PostMessage, 0x111, 32880, 0, , %ClearCaseExplorerTitle%
  }
  ;; when VersionPropertiesShortcut -> Version Properties
  else if MyKey = %VersionPropertiesShortcut%
  {
    ;; WinMenuSelectItem cannot be used with clearcase explorer like outlook, etc
    ;; Send message WM_COMMAND (0x111) to the clearcase explorer window
    ;; with 0x8071 wParam and 0 lParam (version properties in menu)
    PostMessage, 0x111, 32881, 0, , %ClearCaseExplorerTitle%
  }
  ;; other characters are not considered
}
Return

;;
;;; get the dir from find checkouts
GetClearCaseExplorerDir()
{
  global ClearCaseExplorerTitle

  WinGetTitle, dirPath, %ClearCaseExplorerTitle%
  dirPath := RegExReplace(dirPath, "^.*\((.*)\).*$", "$1")

  Return dirPath
}

;;
;;; get the file from history browser
GetClearCaseExplorerFile()
{
  file := GetClearCaseExplorerSelectedFile()
  dir := GetClearCaseExplorerDir()
  filePath := % dir . "\" . file

  Return filePath
}

;;
;;; get the selected file path
GetClearCaseExplorerSelectedFile()
{
   global SoftwareName, ClearCaseExplorerTitle

   ;; init filename
   file = ""
   ControlGet, selectedFiles, List, Selected Col1, SysListView322, %ClearCaseExplorerTitle%
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

;
;;
;;; TREE VERSION
;===============================================================================
;;
;;; sub function to call function (needed to not define global variable)
CheckShortcutTreeVersion:
  CheckShortcutTreeVersionFunction()
Return
;;
;;; check shortcut after prefix and run associated function
CheckShortcutTreeVersionFunction()
{
  global CheckOutShortcut, CheckInShortcut, UnCheckOutShortcut, HistoryShortcut, ComparePrevShortcut
  global TreeVersionShortcut, ExplorerShortcut, FindCheckoutShortcut, ElementPropertiesShortcut
  global VersionPropertiesShortcut, ClearCaseTreeVersionTitle, SoftwareName

  ;; capture next key
  Input, MyKey, L1 T2, {Escape}
  ;; when timeout quit
  if ErrorLevel = Timeout
    return
  ;; when CheckOutShortcut -> Checkout
  if MyKey = %CheckOutShortcut%
    WinMenuSelectItem, %ClearCaseTreeVersionTitle%, , Tools, Check Out...
  ;; when CheckInShortcut -> Checkin
  else if MyKey = %CheckInShortcut%
    WinMenuSelectItem, %ClearCaseTreeVersionTitle%, , Tools, Check In...
  ;; when UnCheckOutShortcut -> Uncheckout
  else if MyKey = %UnCheckOutShortcut%
    WinMenuSelectItem, %ClearCaseTreeVersionTitle%, , Tools, Undo Checkout...
  ;; when HistoryShortcut -> History
  else if MyKey = %HistoryShortcut%
    WinMenuSelectItem, %ClearCaseTreeVersionTitle%, , Tools, History
  ;; when ComparePrevShortcut -> Diff
  else if MyKey = %ComparePrevShortcut%
    WinMenuSelectItem, %ClearCaseTreeVersionTitle%, , Tools, Compare, with Previous Version
  ;; when TreeVersionShortcut -> Tree Version
  else if MyKey = %TreeVersionShortcut%
     Send {F5}
  ;; when ExplorerShortcut -> ClearCase Explorer
  else if MyKey = %ExplorerShortcut%
  {
    MsgBox, 0x10, %SoftwareName%, Cannot open ClearCase Explorer from Tree Version.
  }
  ;; when FindCheckoutShortcut -> Find Checkout
  else if MyKey = %FindCheckoutShortcut%
  {
    MsgBox, 0x10, %SoftwareName%, Cannot open ClearCase Find Checkout from Tree Version.
  }
  ;; when ElementPropertiesShortcut -> Element Properties
  else if MyKey = %ElementPropertiesShortcut%
  {
    MsgBox, 0x10, %SoftwareName%, Cannot open ClearCase Element Properties from Tree Version.
  }
  ;; when VersionPropertiesShortcut -> Version Properties
  else if MyKey = %VersionPropertiesShortcut%
    WinMenuSelectItem, %ClearCaseTreeVersionTitle%, , Tools, Properties
  ;; other characters are not considered
}
Return

;
;;
;;; ULTRAEDIT
;===============================================================================
;;
;;; sub function to call function (needed to not define global variable)
CheckShortcutUltraEdit:
  CheckShortcutUltraEditFunction()
Return
;;
;;; check shortcut after prefix and run associated function
CheckShortcutUltraEditFunction()
{
  global CheckOutShortcut, CheckInShortcut, UnCheckOutShortcut, HistoryShortcut, ComparePrevShortcut
  global TreeVersionShortcut, ExplorerShortcut, FindCheckoutShortcut, ElementPropertiesShortcut
  global VersionPropertiesShortcut, UltraEditTitle

  ;; capture next key
  Input, MyKey, L1 T2, {Escape}
  ;; when timeout quit
  if ErrorLevel = Timeout
    return
  ;; when CheckOutShortcut -> Checkout
  if MyKey = %CheckOutShortcut%
  {
    file := GetUltraEditFile()
    CCCheckout(file)
  }
  ;; when CheckInShortcut -> Checkin
  else if MyKey = %CheckInShortcut%
  {
    file := GetUltraEditFile()
    CCCheckin(file)
  }
  ;; when UnCheckOutShortcut -> Uncheckout
  else if MyKey = %UnCheckOutShortcut%
  {
    file := GetUltraEditFile()
    CCUncheckout(file)
  }
  ;; when HistoryShortcut -> History
  else if MyKey = %HistoryShortcut%
  {
    file := GetUltraEditFile()
    CCHistory(file)
  }
  ;; when ComparePrevShortcut -> Diff
  else if MyKey = %ComparePrevShortcut%
  {
    file := GetUltraEditFile()
    CCDiff(file)
  }
  ;; when TreeVersionShortcut -> Tree Version
  else if MyKey = %TreeVersionShortcut%
  {
    file := GetUltraEditFile()
    CCTreeVersion(file)
  }
  ;; when ExplorerShortcut -> ClearCase Explorer
  else if MyKey = %ExplorerShortcut%
  {
    dir := GetUltraEditDir()
    CCExplorer(dir)
  }
  ;; when FindCheckoutShortcut -> Find Checkout
  else if MyKey = %FindCheckoutShortcut%
  {
    dir := GetUltraEditDir()
    CCFindCheckout(dir)
  }
  ;; when ElementPropertiesShortcut -> Element Properties
  else if MyKey = %ElementPropertiesShortcut%
  {
    file := GetUltraEditFile()
    CCElementProperties(file)
  }
  ;; when VersionPropertiesShortcut -> Version Properties
  else if MyKey = %VersionPropertiesShortcut%
  {
    file := GetUltraEditFile()
    CCVersionProperties(file)
  }
  ;; other characters are not considered
}
Return

;;
;;; get the file from history browser
GetUltraEditFile()
{
  global UltraEditTitle

  WinTitle := RegExReplace(UltraEditTitle, "(.*) ahk_exe.*", "$1")

  WinGetTitle, myTitle, %UltraEditTitle%
  StringReplace, filePath, myTitle, %WinTitle%
  StringTrimRight, filePath, filePath, 1

  Return filePath
}

;;
;;; get the dir from history browser
GetUltraEditDir()
{
  filePath := GetUltraEditFile()
  SplitPath, filePath, , dirPath

  Return dirPath
}

;
;;
;;; EMACS
;===============================================================================
;;
;;; sub function to call function (needed to not define global variable)
CheckShortcutEmacs:
  CheckShortcutEmacsFunction()
Return
;;
;;; check shortcut after prefix and run associated function
CheckShortcutEmacsFunction()
{
  global CheckOutShortcut, CheckInShortcut, UnCheckOutShortcut, HistoryShortcut, ComparePrevShortcut
  global TreeVersionShortcut, ExplorerShortcut, FindCheckoutShortcut, ElementPropertiesShortcut
  global VersionPropertiesShortcut, EmacsTitle

  ;; capture next key
  Input, MyKey, L1 T2, {Escape}
  ;; when timeout quit
  if ErrorLevel = Timeout
    return
  ;; block any input from user
  BlockInput, On
  ;; when CheckOutShortcut -> Checkout
  if MyKey = %CheckOutShortcut%
  {
    SendInput, {Alt Down}x{Alt Up}clearcase-gui-checkout{Enter}
  }
  ;; when CheckInShortcut -> Checkin
  else if MyKey = %CheckInShortcut%
  {
    SendInput, {Alt Down}x{Alt Up}clearcase-gui-checkin{Enter}
  }
  ;; when UnCheckOutShortcut -> Uncheckout
  else if MyKey = %UnCheckOutShortcut%
  {
    SendInput, {Alt Down}x{Alt Up}clearcase-gui-uncheckout{Enter}
  }
  ;; when HistoryShortcut -> History
  else if MyKey = %HistoryShortcut%
  {
    SendInput, {Alt Down}x{Alt Up}clearcase-gui-history{Enter}
  }
  ;; when ComparePrevShortcut -> Diff
  else if MyKey = %ComparePrevShortcut%
  {
    SendInput, {Alt Down}x{Alt Up}clearcase-gui-diff-prev{Enter}
  }
  ;; when TreeVersionShortcut -> Tree Version
  else if MyKey = %TreeVersionShortcut%
  {
    SendInput, {Alt Down}x{Alt Up}clearcase-gui-version-tree{Enter}
  }
  ;; when ExplorerShortcut -> ClearCase Explorer
  else if MyKey = %ExplorerShortcut%
  {
    SendInput, {Alt Down}x{Alt Up}clearcase-gui-explorer{Enter}
  }
  ;; when FindCheckoutShortcut -> Find Checkout
  else if MyKey = %FindCheckoutShortcut%
  {
    SendInput, {Alt Down}x{Alt Up}clearcase-gui-find-checkout{Enter}
  }
  ;; when ElementPropertiesShortcut -> Element Properties
  else if MyKey = %ElementPropertiesShortcut%
  {
    SendInput, {Alt Down}x{Alt Up}clearcase-gui-properties{Enter}
  }
  ;; when VersionPropertiesShortcut -> Version Properties
  else if MyKey = %VersionPropertiesShortcut%
  {
    SendInput, {Alt Down}x{Alt Up}clearcase-gui-version-properties{Enter}
  }
  ;; other characters are not considered
  ;; unblock any input from user
  BlockInput, Off
}
Return

;
;;
;;; PROPERTIES
;===============================================================================
#ifWinActive ahk_class #32770 ahk_exe cleardescribe.exe
;; resize properties description area
~WheelDown::SetPositionPropertiesVersion(100, 200, "ahk_class #32770 ahk_exe cleardescribe.exe")
#ifWinActive

;;
;;;
SetPositionPropertiesVersion(MoveSizeX, MoveSizeY, Window)
{
  ;; get position of the list of object
  ControlGetPos, X, Y, W, H, Edit5, %Window%

  ControlGetText, myText, #327701, %Window%

  IfInString, myText, General
  {
    ;; when the button are in the original position
    if (W < 235 or H < 69)
    {
      ;; set position of the "Description:" Edit
      SetPositionAndSizeControl("Edit5", 0, 0, MoveSizeX, MoveSizeY, Window)
      ;; set position of the "Predecessor:" Label
      SetPositionAndSizeControl("Static7", 0, MoveSizeY, 0, 0, Window)
      ;; set position of the "Predecessor:" Edit
      SetPositionAndSizeControl("Edit6", 0, MoveSizeY, 0, 0, Window)
      ;; set position of the "In view:" Label
      SetPositionAndSizeControl("Static8", 0, MoveSizeY, 0, 0, Window)
      ;; set position of the "In view:" Edit
      SetPositionAndSizeControl("Edit7", 0, MoveSizeY, 0, 0, Window)
      ;; set position of the "Reserved:" button
      SetPositionAndSizeControl("Button1", 0, MoveSizeY, 0, 0, Window)
      ;; set position of the "OK" button
      SetPositionAndSizeControl("Button4", 0, MoveSizeY, 0, 0, Window)
      ;; set position of the "Annuler" button
      SetPositionAndSizeControl("Button5", 0, MoveSizeY, 0, 0, Window)
      ;; set position of the "Appliquer" button
      SetPositionAndSizeControl("Button6", 0, MoveSizeY, 0, 0, Window)
      ;; set position of the "Aide" button
      SetPositionAndSizeControl("Button7", 0, MoveSizeY, 0, 0, Window)

      ;; set position of the "General" tab
      SetPositionAndSizeControl("#327701", 0, 0, MoveSizeX, MoveSizeY, Window)
      SetPositionAndSizeControl("#32770", 0, 0, MoveSizeX, MoveSizeY, Window)
      SetPositionAndSizeControl("SysTabControl321", 0, 0, MoveSizeX, MoveSizeY, Window)

      ;; get the style
      ControlGet, Style, Style, , Edit5, %Window%

      ControlGet, hwid, Hwnd, , Edit5, %Window%

      ;; add WS_VSCROLL
      Style := Style | 0x200000

      ;; set the style (do not work ???)
      Control, Style, %Style%, , ahk_id %hwid%

      ;; set the size of the window
      SetSizeWindow(MoveSizeX, MoveSizeY, Window)
    }
  }
}
Return

;;; shift a control and extend it
;; /Parameter:  ClassButton:            class of the button
;;              MoveSizeX:              horizontal increment of the shift
;;              MoveSizeY:              vertical increment of the shift
;;              WidthSize:              new width of the button
;;              HeightSize:             new height of the button
SetPositionAndSizeControl(ClassButton, MoveSizeX, MoveSizeY, WidthSize, HeightSize, Window)
{
  ;; get position of the control
  ControlGetPos, X, Y, W, H, %ClassButton%, %Window%
  ;; add pixels of position
  X += MoveSizeX
  Y += MoveSizeY
  ;; add pixels of size
  W += WidthSize
  H += HeightSize
  ;; move the control and/or extended
  ControlMove, %ClassButton%, %X%, %Y%, %W%, %H%, %Window%
}
Return

;;; shift a control and extend it
;; /Parameter:  ClassButton:            class of the button
;;              MoveSizeX:              horizontal increment of the resize
;;              MoveSizeY:              vertical increment of the resize
SetSizeWindow(MoveSizeX, MoveSizeY, Window)
{
  ;; get size of the window
  WinGetPos, , , WinW, WinH, %Window%
  ;; increment the width of the window
  WinH += MoveSizeY
  ;; increment the height of the window
  WinW += MoveSizeX
  ;; set the size of the window
  WinMove, %Window%, , , , %WinW%, %WinH%
}
Return



;
;;
;;; FUNCTIONS
;===============================================================================
;;
;;; show checkout window about selected file
CCCheckout(filePath)
{
  if filePath != ""
  {
    Run, cleardlg.exe /window 5061e /windowmsg A065 /checkout "%filePath%"
  }
}
Return

;;
;;; show checkin window about selected file
CCCheckin(filePath)
{
  if filePath != ""
  {
    Run, cleardlg.exe /window 606f6 /windowmsg A065 /checkin "%filePath%"
  }
}
Return

;;
;;; show uncheckout window about selected file
CCUncheckout(filePath)
{
  if filePath != ""
  {
    Run, cleardlg.exe /window c04ca /windowmsg A065 /uncheckout "%filePath%"
  }
}
Return

;;
;;; show history about selected file
CCHistory(filePath)
{
  if filePath != ""
  {
    Run, clearhistory.exe "%filePath%"
  }
}
Return

;;
;;; show diff with previous file about selected file
CCDiff(filePath)
{
  if filePath != ""
  {
    Run, cleartool.exe diff -graphical -predecessor "%filePath%"
  }
}
Return

;;
;;; show tree version about selected file
CCTreeVersion(filePath)
{
  if filePath != ""
  {
    Run, clearvtree.exe "%filePath%"
  }
}
Return

;;
;;; show explorer about selected file
CCExplorer(dirPath)
{
  if dirPath != ""
  {
    Run, clearexplorer.exe "%dirPath%"
  }
}
Return

;;
;;; show find checkout about selected file
CCFindCheckout(dirPath)
{
  if dirPath != ""
  {
    Run, clearfindco.exe "%dirPath%"
  }
}
Return

;;
;;; show element properties about selected file
CCElementProperties(filePath)
{
  if filePath != ""
  {
    Run, cleardescribe.exe "%filePath%@@"
  }
}
Return

;;
;;; show version properties about selected file
CCVersionProperties(filePath)
{
  if filePath != ""
  {
    Run, cleardescribe.exe "%filePath%"
  }
}
Return

;
;;
;;; MENU + GUI
;===============================================================================
;;
;;; handler of the item about
MenuAbout:
  Gui, AboutHelp_:Margin, 30, 10
  Gui, AboutHelp_:Add, Text, 0x1, % SoftwareName "`nVersion " . SoftwareVersion
  Gui, AboutHelp_:Show, AutoSize, About %SoftwareName%
Return

;;
;;; handler of the item help
MenuHelp:
  StringReplace, MainKey, MainShortcut, +, % "Shift + "
  StringReplace, MainKey, MainKey, ^, % "Ctrl + "
  StringReplace, MainKey, MainKey, !, % "Alt + "
  StringReplace, MainKey, MainKey, #, % "Win + "
  Gui, AboutHelp_:Add, Text, ,
(
All these shortcuts are functional in MS Explorer, CC History Browser, CC Find checkout, CC Explorer, CC Tree Version, UltraEdit.
        %MainKey%   %CheckOutShortcut%`t`tCheckout
        %MainKey%   %CheckInShortcut%`t`tCheckIn
        %MainKey%   %UnCheckOutShortcut%`t`tUnCheckOut
        %MainKey%   %HistoryShortcut%`t`tHistory Browser
        %MainKey%   %ComparePrevShortcut%`t`tCompare with previous
        %MainKey%   %TreeVersionShortcut%`t`tTree Version Browser
        %MainKey%   %ExplorerShortcut%`t`tClearCase Explorer `(not working in CC Tree Version`)
        %MainKey%   %FindCheckoutShortcut%`t`tFind Checkouts `(not working in CC Tree Version`)
        %MainKey%   %ElementPropertiesShortcut%`t`tElement Properties `(not working in CC Tree Version`)
        %MainKey%   %VersionPropertiesShortcut%`t`tVersion Properties
)
  Gui, AboutHelp_:Show, AutoSize, Help %SoftwareName%
Return

;;
;;; handler for the about and help window
AboutHelp_GuiClose:
AboutHelp_GuiEscape:
  ;; destroy the window without saving anything
  Gui, Destroy
Return

;;
;;; handler of the item Reload .ini
MenuReload:
  GoSub, LoadIniFile
Return

;;
;;; handler for the item shortcut
MenuOptions:
  ;; when the shortcut contains # (so window key)
  IfInString, MainShortcut, #
  {
     WinKey := 1
     ;; remove all #
     StringReplace, Shortcut, MainShortcut, #, , All
  }
  else
  {
     WinKey := 0
     Shortcut = %MainShortcut%
  }
  ;;
  ;; frame with title
  Gui, Options_:Add, GroupBox, x10 y3 W270 h45, Main shortcut (shortcuts prefix)
  ;; checkbox for window key, checked depends on WinKey variable
  Gui, Options_:Add, CheckBox, xp+15 yp+19 Section Checked%WinKey% vWindowKey, Windows +
  ;; edit area to enter hotkey
  Gui, Options_:Add, Hotkey, ys-4 w155 vKey, %Shortcut%

  labelWidth := 110
  ;; frame with title (w270 = 15 + 110 + 10 + 120 + 15)
  Gui, Options_:Add, GroupBox, x10 W270 h250, Shortcuts
  ;; label for checkout shortcut
  Gui, Options_:Add, Text, xp+15 yp+19 w%labelWidth% Section, CheckOut:
  ;; add a edit area to enter hotkey for checkout shortcut
  Gui, Options_:Add, Hotkey, ys-4 vKeyCheckout, %CheckOutShortcut%
  ;; label for checkin shortcut
  Gui, Options_:Add, Text, xs w%labelWidth% Section, CheckIn:
  ;; add a edit area to enter hotkey for checkin shortcut
  Gui, Options_:Add, Hotkey, ys-4 vKeyCheckin, %CheckInShortcut%
  ;; label for uncheckout shortcut
  Gui, Options_:Add, Text, xs w%labelWidth% Section, UnCheckOut:
  ;; add a edit area to enter hotkey for uncheckout shortcut
  Gui, Options_:Add, Hotkey, ys-4 vKeyUnCheckout, %UnCheckOutShortcut%
  ;; label for history shortcut
  Gui, Options_:Add, Text, xs w%labelWidth% Section, History:
  ;; add a edit area to enter hotkey for history shortcut
  Gui, Options_:Add, Hotkey, ys-4 vKeyHistory, %HistoryShortcut%
  ;; label for compare with previous shortcut
  Gui, Options_:Add, Text, xs w%labelWidth% Section, Compare with previous:
  ;; add a edit area to enter hotkey for compare with previous shortcut
  Gui, Options_:Add, Hotkey, ys-4 vKeyComparePrev, %ComparePrevShortcut%
  ;; label for tree version shortcut
  Gui, Options_:Add, Text, xs w%labelWidth% Section, Tree Version:
  ;; add a edit area to enter hotkey for tree version shortcut
  Gui, Options_:Add, Hotkey, ys-4 vKeyTreeVersion, %TreeVersionShortcut%
  ;; label for explorer shortcut
  Gui, Options_:Add, Text, xs w%labelWidth% Section, Explorer:
  ;; add a edit area to enter hotkey for explorer shortcut
  Gui, Options_:Add, Hotkey, ys-4 vKeyExplorer, %ExplorerShortcut%
  ;; label for find checkouts shortcut
  Gui, Options_:Add, Text, xs w%labelWidth% Section, Find checkouts:
  ;; add a edit area to enter hotkey for find checkouts shortcut
  Gui, Options_:Add, Hotkey, ys-4 vKeyFindCheckout, %FindCheckoutShortcut%
  ;; label for element properties shortcut
  Gui, Options_:Add, Text, xs w%labelWidth% Section, Element Properties:
  ;; add a edit area to enter hotkey for element properties shortcut
  Gui, Options_:Add, Hotkey, ys-4 vKeyElementProperties, %ElementPropertiesShortcut%
  ;; label for version properties shortcut
  Gui, Options_:Add, Text, xs w%labelWidth% Section, Version Properties:
  ;; add a edit area to enter hotkey for version properties shortcut
  Gui, Options_:Add, Hotkey, ys-4 vKeyVersionProperties, %VersionPropertiesShortcut%
  ;;
  ;; add a button "SetShortcuts" will go to the sub SetShortcut ((10 + 270 - 70 - 10 - 70 + 10) / 2 = 60)
  Gui, Options_:Add, Button, x70 w70 Section Default, OK
  Gui, Options_:Add, Button, w70 ys, Cancel
  ;; display the gui + set window title
  Gui, Options_:Show, AutoSize, Escape to cancel
Return

;;
;;: handler for the set shortcut window
Options_GuiClose:
Options_GuiEscape:
Options_ButtonCancel:
  ;; destroy the window without saving anything
  Gui, Destroy
Return

;;
;;; handler for the OK button of set shortcut window
Options_ButtonOK:
  ;; get the key and the checkbox for window key
  GuiControlGet, Key
  GuiControlGet, WindowKey
  ;; remove the gui
  Gui, Destroy
  ;; when the checkbox window key is checked
  If WindowKey = 1
  {
    ;; prefix shortcut with #
    Key = % "#" Key
  }
  ;; unset previous shortcut
  SetTitleMatchMode, Regex
  Hotkey, IfWinActive, %ExplorerTitle%
  HotKey, %MainShortcut%, CheckShortcutExplorer, Off
  SetTitleMatchMode, 1
  Hotkey, IfWinActive, %ClearCaseFindCheckoutTitle%
  Hotkey, %MainShortcut%, CheckShortcutFindCheckout, Off
  Hotkey, IfWinActive, %ClearCaseHistoryTitle%
  Hotkey, %MainShortcut%, CheckShortcutHistory, Off
  Hotkey, IfWinActive, %ClearCaseExplorerTitle%
  Hotkey, %MainShortcut%, CheckShortcutClearCaseExplorer, Off
  Hotkey, IfWinActive, %UltraEditTitle%
  Hotkey, %MainShortcut%, CheckShortcutUltraEdit, Off
  Hotkey, IfWinActive, %EmacsTitle%
  Hotkey, %MainShortcut%, CheckShortcutEmacs, Off
  Hotkey, IfWinActive
  ;; when key already exist
  HotKey, %Key%, , UseErrorLevel
;;  MsgBox, toto, %ErrorLevel%
  If ErrorLevel = 6
  {
    ;; enable new shortcut
    SetTitleMatchMode, Regex
    Hotkey, IfWinActive, %ExplorerTitle%
    HotKey, %Key%, , On
    SetTitleMatchMode, 1
    Hotkey, IfWinActive, %ClearCaseFindCheckoutTitle%
    Hotkey, %Key%, , On
    Hotkey, IfWinActive, %ClearCaseHistoryTitle%
    Hotkey, %Key%, , On
    Hotkey, IfWinActive, %ClearCaseExplorerTitle%
    Hotkey, %Key%, , On
    Hotkey, IfWinActive, %UltraEditTitle%
    Hotkey, %Key%, , On
    Hotkey, IfWinActive, %EmacsTitle%
    Hotkey, %Key%, , On
    Hotkey, IfWinActive
  }
  ;; set new shortcut
  SetTitleMatchMode, Regex
  Hotkey, IfWinActive, %ExplorerTitle%
  HotKey, %Key%, CheckShortcutExplorer1
  SetTitleMatchMode, 1
  Hotkey, IfWinActive, %ClearCaseFindCheckoutTitle%
  Hotkey, %Key%, CheckShortcutFindCheckout
  Hotkey, IfWinActive, %ClearCaseHistoryTitle%
  Hotkey, %Key%, CheckShortcutHistory
  Hotkey, IfWinActive, %ClearCaseExplorerTitle%
  Hotkey, %Key%, CheckShortcutClearCaseExplorer
  Hotkey, IfWinActive, %UltraEditTitle%
  Hotkey, %Key%, CheckShortcutUltraEdit
  Hotkey, IfWinActive, %EmacsTitle%
  Hotkey, %Key%, CheckShortcutEmacs
  Hotkey, IfWinActive
  ;; set new shortcut and write in ini file
  MainShortcut = %Key%
  GoSub, MenuCreateSaveIni
Return

;;
;;; load all setting from ini file if they exist otherwise default value
LoadIniFile:
  ;; shortcuts
  IniRead, MainShortcut,              %IniFile%, Shortcut, MainShortcut,              #c
  IniRead, CheckOutShortcut,          %IniFile%, Shortcut, CheckOutShortcut,          c
  IniRead, CheckInShortcut,           %IniFile%, Shortcut, CheckInShortcut,           i
  IniRead, UnCheckOutShortcut,        %IniFile%, Shortcut, UnCheckOutShortcut,        u
  IniRead, HistoryShortcut,           %IniFile%, Shortcut, HistoryShortcut,           h
  IniRead, ComparePrevShortcut,       %IniFile%, Shortcut, ComparePrevShortcut,       =
  IniRead, TreeVersionShortcut,       %IniFile%, Shortcut, TreeVersionShortcut,       t
  IniRead, ExplorerShortcut,          %IniFile%, Shortcut, ExplorerShortcut,          e
  IniRead, FindCheckoutShortcut,      %IniFile%, Shortcut, FindCheckoutShortcut,      f
  IniRead, ElementPropertiesShortcut, %IniFile%, Shortcut, ElementPropertiesShortcut, p
  IniRead, VersionPropertiesShortcut, %IniFile%, Shortcut, VersionPropertiesShortcut, v
  ;;
  ;; window titles
  IniRead, ExplorerTitle,              %IniFile%, Title, Explorer1Title, ahk_class CabinetWClass|ExploreWClass
  IniRead, ClearCaseFindCheckoutTitle, %IniFile%, Title, ClearCaseFindCheckoutTitle, Find Checkouts ahk_exe clearfindco.exe
  IniRead, ClearCaseHistoryTitle,      %IniFile%, Title, ClearCaseHistoryTitle, Rational ClearCase History Browser - ahk_exe clearhistory.exe
  IniRead, ClearCaseExplorerTitle,     %IniFile%, Title, ClearCaseExplorerTitle, Rational ClearCase Explorer - ahk_exe clearexplorer.exe
  IniRead, ClearCaseTreeVersionTitle,  %IniFile%, Title, ClearCaseTreeVersionTitle, ahk_exe clearvtree.exe
  IniRead, UltraEditTitle,             %IniFile%, Title, UltraEditTitle, UltraEdit-32 - [ ahk_exe uedit32.exe
  IniRead, EmacsTitle,                 %IniFile%, Title, EmacsTitle, ahk_exe emacs.exe
Return

;;
;;; Edit a ini file
MenuEditIni:
  ;; Launch default editor maximized.
  Run, %IniFile%, , Max UseErrorLevel
  ;; when error to launch
  if ErrorLevel = ERROR
    MsgBox, 0x10, %SoftwareName%, cannot access %IniFile%: No such file or directory.`n(Use before "Create/Save .ini file")
Return

;;
;;; Save all settings in a ini file
MenuCreateSaveIni:
  ;; Section Shortcut
  IniWrite, %MainShortcut%,              %IniFile%, Shortcut, MainShortcut
  IniWrite, %CheckOutShortcut%,          %IniFile%, Shortcut, CheckOutShortcut
  IniWrite, %CheckInShortcut%,           %IniFile%, Shortcut, CheckInShortcut
  IniWrite, %UnCheckOutShortcut%,        %IniFile%, Shortcut, UnCheckOutShortcut
  IniWrite, %HistoryShortcut%,           %IniFile%, Shortcut, HistoryShortcut
  IniWrite, %ComparePrevShortcut%,       %IniFile%, Shortcut, ComparePrevShortcut
  IniWrite, %TreeVersionShortcut%,       %IniFile%, Shortcut, TreeVersionShortcut
  IniWrite, %ExplorerShortcut%,          %IniFile%, Shortcut, ExplorerShortcut
  IniWrite, %FindCheckoutShortcut%,      %IniFile%, Shortcut, FindCheckoutShortcut
  IniWrite, %ElementPropertiesShortcut%, %IniFile%, Shortcut, ElementPropertiesShortcut
  IniWrite, %VersionPropertiesShortcut%, %IniFile%, Shortcut, VersionPropertiesShortcut
  ;; Section Title
  IniWrite, %ExplorerTitle%,              %IniFile%, Title, ExplorerTitle
  IniWrite, %ClearCaseFindCheckoutTitle%, %IniFile%, Title, ClearCaseFindCheckoutTitle
  IniWrite, %ClearCaseHistoryTitle%,      %IniFile%, Title, ClearCaseHistoryTitle
  IniWrite, %ClearCaseExplorerTitle%,     %IniFile%, Title, ClearCaseExplorerTitle
  IniWrite, %ClearCaseTreeVersionTitle%,  %IniFile%, Title, ClearCaseTreeVersionTitle
  IniWrite, %UltraEditTitle%,             %IniFile%, Title, UltraEditTitle
  IniWrite, %EmacsTitle%,                 %IniFile%, Title, EmacsTitle
  ;;
  ;; display a traytip to indicate file save
  TrayTip, %SoftwareName%, %IniFile% file saved., 5, 1
Return
