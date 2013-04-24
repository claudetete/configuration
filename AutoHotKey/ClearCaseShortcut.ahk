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
;; Version: 1.8
;; Created: February 2012
;; Last-Updated: April 2013

;;; Commentary:
;;
;; TODO: cannot get file path from tree version window ?

;;; Change Log:
;; 2013-04-18 (1.8)
;;    add copy to clipboard numero_ECS attribute + fix bug when reload ini with
;;    title window + add multiple checkout, checkin, etc
;; 2013-04-17 (1.7)
;;    contextual menu can be disable + add to source control + fix bug with
;;    ultraedit + icon in contextual menu + contextual menu place are set in ini
;; 2013-04-16 (1.6)
;;   remove emacs + add contextual menu + edit config spec
;; 2013-02-26 (1.5)
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
;; regex title match
SetTitleMatchMode, Regex

;
;;
;;; SETTINGS
;; name of script
SoftwareName = ClearCaseShortcut
;; version of script
SoftwareVersion = 1.8
;; init for contextual menu
ContextMenu_OK := False

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
;;; TITLE GROUP
CreateGroupTitle()

;
;;
;;; SHORTCUT
;; init prefix hotkey and contextual menu
HotKey, IfWinActive, ahk_group %GroupWindowTitle%
Hotkey, %MainShortcut%, CheckShortcut
if ContextMenuEnable = 1
{
  ;; enable contextual
  HotKey, $RButton, RightClickButton
  HotKey, $RButton Up, RightClickUpButton
}
Hotkey, IfWinActive

;
;;
;;; MENU
Menu, Tray, Icon, clearexplorer.exe
;; Delete the current menu
Menu, Tray, NoStandard
;; Add the item About in the menu
Menu, Tray, add, About, MenuAbout
;; Add the item Help in the menu
Menu, Tray, add, Help, MenuHelp
;; Creates a separator line.
Menu, Tray, add
;; Add the item Shortcuts in the menu
Menu, Tray, add, Options, MenuOptions
;; Add the item Reload in the menu
Menu, Tray, add, Reload .ini file, MenuReload
;; Add the item Edit ini in the menu
Menu, Tray, add, Edit .ini file, MenuEditIni
;; Add the item Create/Save ini in the menu
Menu, Tray, add, Create/Save .ini file, MenuCreateSaveIni
;; Creates a separator line.
Menu, Tray, add
;; add the standard menu
Menu, Tray, Standard


;; End of script
return


;
;;
;;; INPUT
;===============================================================================
;===============================================================================
;;
;;; capture next key and execute associated function
CheckShortcut:
  ;; detect active window
  WinName := GetActiveWindowName()

  ;; capture next key
  Input, MyKey, L1 T2, {Escape}
  ;; when timeout quit
  if ErrorLevel = Timeout
    return
  ;; when CheckOutShortcut Checkout
  if MyKey = %CheckOutShortcut%
  {
    ShowCheckout(WinName)
  }
  ;; when CheckInShortcut -> Checkin
  else if MyKey = %CheckInShortcut%
  {
    ShowCheckIn(WinName)
  }
  ;; when UnCheckOutShortcut -> Uncheckout
  else if MyKey = %UnCheckOutShortcut%
  {
    ShowUnCheckOut(WinName)
  }
  ;; when HistoryShortcut -> History
  else if MyKey = %HistoryShortcut%
  {
    ShowHistory(WinName)
  }
  ;; when ComparePrevShortcut -> Diff
  else if MyKey = %ComparePrevShortcut%
  {
    ShowComparePrev(WinName)
  }
  ;; when TreeVersionShortcut -> Tree Version
  else if MyKey = %TreeVersionShortcut%
  {
    ShowTreeVersion(WinName)
  }
  ;; when ExplorerShortcut -> ClearCase Explorer
  else if MyKey = %ExplorerShortcut%
  {
    ShowExplorer(WinName)
  }
  ;; when FindCheckoutShortcut -> Find Checkout
  else if MyKey = %FindCheckoutShortcut%
  {
    ShowFindCheckout(WinName)
  }
  ;; when ElementPropertiesShortcut -> Element Properties
  else if MyKey = %ElementPropertiesShortcut%
  {
    ShowElementProperties(WinName)
  }
  ;; when VersionPropertiesShortcut -> Version Properties
  else if MyKey = %VersionPropertiesShortcut%
  {
    ShowVersionProperties(WinName)
  }
  ;; when AddToSourceControlShortcut -> Add to Source Control
  else if MyKey = %AddToSourceControlShortcut%
  {
    ShowAddToSourceControl(WinName)
  }
  ;; when GetECSNumberShortcut -> get numero_ECS attribute
  else if MyKey = %GetECSNumberShortcut%
  {
    GetECSNumber(WinName)
  }
  ;; when VersionPropertiesShortcut -> Version Properties
  else if MyKey = %EditConfigSpecShortcut%
  {
    ContextMenuWindowName = %WinName%
    GoSub, EditConfigSpecMenu
  }
  ;; other characters are not considered
Return

;;
;;; call sub function to manage context menu
RightClickButton:
  if ContextMenuEnable = 1
  {
    IfWinActive, ahk_group %GroupWindowTitle%
    {
      ;; call contextual menu only after a timer
      SetTimer, ContextMenu, %ContextMenuTime%
    }
    else
    {
      ;; not a covered app
      Send, {RButton Down}
    }
  }
  else
  {
    ;; contextual menu is disable
    Send, {RButton Down}
  }
Return

;;
;;; send right click up
RightClickUpButton:
  if ContextMenuEnable = 1
  {
    ;; disable timer
    SetTimer, ContextMenu, off

    IfWinActive, ahk_group %GroupWindowTitle%
    {
      Send, {RButton Down}{RButton Up}
    }
    else
    {
      Send, {RButton Up}
    }
  }
  else
  {
    ;; contextual menu is disable
    Send, {RButton Up}
  }
Return

;;
;;; Contextual Menu handler
ContextMenu:
{
  ;; disable timer for right click
  SetTimer, ContextMenu, off

 ;; do a left click to select
  MouseClick, L, , , , 0

  ;; after show contextual menu it is not the active window
  ContextMenuWindowName := GetActiveWindowName()

  if StrLen(ContextMenuWindowName)
  {
    ;; set gui only once
    if (!ContextMenu_OK)
    {
      i := 0
      While (i != ContextMenuMax)
      {
        if i = %ContextMenuPlaceExplorer%
        {
          Menu, Context_, Add,  ClearCase Explorer, ShowExplorerMenu
          Menu, Context_, Icon, ClearCase Explorer, clearexplorer.exe, 1
        }
        else if i = %ContextMenuPlaceFindCheckout%
        {
          Menu, Context_, Add,  Find Checkouts, ShowFindCheckoutMenu
          Menu, Context_, Icon, Find Checkouts, clearfindco.exe, 1
        }
        else if i = %ContextMenuPlaceCheckOut%
        {
          Menu, Context_, Add,  Check Out..., ShowCheckOutMenu
          Menu, Context_, Icon, Check Out..., cccmndlg.dll, 39
        }
        else if i = %ContextMenuPlaceCheckIn%
        {
          Menu, Context_, Add,  Check In..., ShowCheckInMenu
          Menu, Context_, Icon, Check In..., cccmndlg.dll, 40
        }
        else if i = %ContextMenuPlaceUnCheckOut%
        {
          Menu, Context_, Add,  Undo Checkout..., ShowUnCheckOutMenu
          Menu, Context_, Icon, Undo Checkout..., cccmndlg.dll, 41
        }
        else if i = %ContextMenuPlaceAddToSourceControl%
        {
          Menu, Context_, Add,  Add to Source Control..., ShowAddToSourceControlMenu
          Menu, Context_, Icon, Add to Source Control..., cccmndlg.dll, 38
        }
        else if i = %ContextMenuPlaceHistory%
        {
          Menu, Context_, Add,  History, ShowHistoryMenu
          Menu, Context_, Icon, History, clearhistory.exe, 1
        }
        else if i = %ContextMenuPlaceTreeVersion%
        {
          Menu, Context_, Add,  Version Tree, ShowTreeVersionMenu
          Menu, Context_, Icon, Version Tree, drawtree.ocx, 4
        }
        else if i = %ContextMenuPlaceComparePrev%
        {
          Menu, Context_, Add,  Compare with Previous Version, ShowComparePrevMenu
          Menu, Context_, Icon, Compare with Previous Version, cleardiffmrg.exe, 1
        }
        else if i = %ContextMenuPlacePropertiesVersion%
        {
          Menu, Context_, Add,  Properties of Version, ShowVersionPropertiesMenu
          Menu, Context_, Icon, Properties of Version, cleardescribe.exe, 1
        }
        else if i = %ContextMenuPlacePropertiesElement%
        {
          Menu, Context_, Add,  Properties of Element, ShowElementPropertiesMenu
        }
        else if i = %ContextMenuPlaceEditConfigSpec%
        {
          Menu, Context_, Add,  Edit Config Spec, EditConfigSpecMenu
          Menu, Context_, Icon, Edit Config Spec, clearvobtool.exe, 1
        }
        else if i = %ContextMenuPlaceGetECSNumber%
        {
          Menu, Context_, Add,  Copy numero_ECS, GetECSNumberMenu
;          Menu, Context_, Icon, Copy numero_ECS,
        }
        else
        {
          Menu, Context_, Add, ; separator
        }

        i += 1
      }

      ContextMenu_OK := true
    }

    Menu, Context_, Show
  }
}
Return

;
;;
;;; INTERNAL FUNCTIONS
;===============================================================================
;===============================================================================
;
;;
;;; EXPLORER
;===============================================================================
;;
;;; get the selected file
GetExplorerFilePath(WindowName)
{
  ;; get the current path
  dir := GetExplorerDirPath(WindowName)
  ;; remove ""
  StringTrimLeft, dir, dir, 1
  StringTrimRight, dir, dir, 1
  ;; get list of selected files
  files := GetExplorerSelectedFile(WindowName)
  ;; set absolute path
  files = `"%dir%\%files%
  StringReplace, files, files, %A_Space%`", %A_Space%`"%dir%\, All

 return files
}

;;
;;; get the current directory
GetExplorerDirPath(WindowName)
{
  ;; get the current path
  ControlGetText dir, Edit1, %WindowName%
  dir = "%dir%"

  Return dir
}

;;
;;; get the selected file path
GetExplorerSelectedFile(WindowName)
{
  global SoftwareName

  ;; get list of selected files (sperated by \n)
  ControlGet, selectedFiles, List, Selected Col1, SysListView321, %WindowName%
  if StrLen(selectedFiles)
  {
    ;; add " at the end
    selectedFiles = %selectedFiles%`"
    ;; replace \n by " "
    StringReplace, selectedFiles, selectedFiles, `n, "%A_Space%", All
  }
  else
  {
    MsgBox, 0x10, %SoftwareName%: error, Error: You must select a file.
  }

  Return selectedFiles
}

;
;;
;;; HISTORY BROWSER
;===============================================================================
;;
;;; get the file from history browser
GetHistoryFile()
{
  global ClearCaseHistoryTitle

  WinTitle := RegExReplace(ClearCaseHistoryTitle, "(.*) ahk_exe.*", "$1")
  WinGetTitle, myTitle, %ClearCaseHistoryTitle%
  StringReplace, filePath, myTitle, %WinTitle%
  StringTrimLeft, filePath, filePath, 1

  filePath = "%filePath%"

  Return filePath
}

;;
;;; get the dir from history browser
GetHistoryDir()
{
  files := GetHistoryFile()
  ;; split with "
  StringSplit, arrayFiles, files, `", %A_Space%
  SplitPath, arrayFiles2, , dirPath

  dirPath = "%dirPath%"

  Return dirPath
}

;
;;
;;; FIND CHECKOUT
;===============================================================================
;;
;;; get the selected file path (surprising it's the same list than MS Explorer)
GetFindCheckoutsSelectedFile()
{
  global ClearCaseFindCheckoutTitle, SoftwareName

  ;; init filename
  file = ""
  ControlGet, selectedFiles, List, Selected Col1, SysListView321, %ClearCaseFindCheckoutTitle%
  if StrLen(selectedFiles)
  {
    ;; add "" at the end
    selectedFiles = "%selectedFiles%"
    ;; replace \n by " "
    StringReplace, selectedFiles, selectedFiles, `n, "%A_Space%", All
    if (RegexMatch(selectedFiles, "^\.*"))
    {
      StringReplace, selectedFiles, selectedFiles, \, /, All
    }
  }
  else
  {
    MsgBox, 0x10, %SoftwareName%: error, Error: You must select a file.
  }

  Return selectedFiles
}

;;
;;; get the dir from find checkouts
GetFindCheckoutsDir()
{
  files := GetFindCheckoutsSelectedFile()
  ;; split with "
  StringSplit, arrayFiles, files, `", %A_Space%
  if (RegexMatch(arrayFiles2, "^\.*"))
  {
    dirPath =
  }
  else
  {
    ;; get only the path of the first file
    SplitPath, arrayFiles2, , dirPath

    dirPath = "%dirPath%"
  }

  Return dirPath
}

;
;;
;;; CLEARCASE EXPLORER
;===============================================================================
;;
;;; get the dir from find checkouts
GetClearCaseExplorerDir()
{
  global ClearCaseExplorerTitle

  WinGetTitle, dirPath, %ClearCaseExplorerTitle%
  dirPath := RegExReplace(dirPath, "^.*\((.*)\).*$", "$1")

  dirPath = "%dirPath%"

  Return dirPath
}

;;
;;; get the file from history browser
GetClearCaseExplorerFile()
{
  files := GetClearCaseExplorerSelectedFile()
  dir := GetClearCaseExplorerDir()
  ;; to remove ""
  StringTrimLeft, dir, dir, 1
  StringTrimRight, dir, dir, 1
  ;; set absolute path
  files = `"%dir%\%files%
  StringReplace, files, files, %A_Space%`", %A_Space%`"%dir%\, All

  Return files
}

;;
;;; get the selected file path
GetClearCaseExplorerSelectedFile()
{
  global SoftwareName, ClearCaseExplorerTitle

  ControlGet, selectedFiles, List, Selected Col1, SysListView322, %ClearCaseExplorerTitle%
  if StrLen(selectedFiles)
  {
    ;; add " at the end
    selectedFiles = %selectedFiles%`"
    ;; replace \n by " "
    StringReplace, selectedFiles, selectedFiles, `n, "%A_Space%", All
  }
  else
  {
    MsgBox, 0x10, %SoftwareName%: error, Error: You must select a file.
  }

  Return selectedFiles
}

;
;;
;;; ULTRAEDIT
;===============================================================================
;;
;;; get the file from history browser
GetUltraEditFile()
{
  global UltraEditTitle

  WinGetTitle, myTitle, %UltraEditTitle%
  ;; get position of [
  StringGetPos, pos, myTitle, [
  ;; string get pos start with 0 so +1 to have number of character to trim
  pos += 1
  ;; remove all left [
  StringTrimLeft, filePath, myTitle, pos
  ;; remove ]
  StringTrimRight, filePath, filePath, 1
  ;; if file need to be save
  if RegexMatch(filePath, "\*$")
  {
    ;; remove *
    StringTrimRight, filePath, filePath, 1
  }
  filePath = "%filePath%"

  Return filePath
}

;;
;;; get the dir from history browser
GetUltraEditDir()
{
  files := GetUltraEditFile()
    ;; split with "
  StringSplit, arrayFiles, files, `", %A_Space%
  SplitPath, arrayFiles2, , dirPath

  dirPath = "%dirPath%"

  Return dirPath
}

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
;;; COMPUTE
;===============================================================================
;;
;;; handler for contextual menu
ShowCheckOutMenu:
{
  ;; ContextMenuWindowName set by ContextMenu handler
  ShowCheckOut(ContextMenuWindowName)
}
Return
;;
;;; Call CheckOut
ShowCheckOut(WindowName)
{
  global ExplorerTitle, ClearCaseFindCheckoutTitle, ClearCaseHistoryTitle, ClearCaseExplorerTitle
  global ClearCaseTreeVersionTitle, UltraEditTitle

  if WindowName = %ExplorerTitle%
  {
    files := GetExplorerFilePath(WindowName)
    CCCheckout(files)
  }
  else if WindowName = %ClearCaseFindCheckoutTitle%
  {
    files := GetFindCheckoutsSelectedFile()
    CCCheckout(files)
  }
  else if WindowName = %ClearCaseHistoryTitle%
  {
    files := GetHistoryFile()
    CCCheckout(files)
  }
  else if WindowName = %ClearCaseExplorerTitle%
  {
    ;; WinMenuSelectItem cannot be used with clearcase explorer like outlook, etc
    ;; Send message WM_COMMAND (0x111) to the clearcase explorer window
    ;; with 0x8004 wParam and 0 lParam (checkout in menu)
    PostMessage, 0x111, 32772, 0, , %ClearCaseExplorerTitle%
  }
  else if WindowName = %ClearCaseTreeVersionTitle%
  {
    WinMenuSelectItem, %ClearCaseTreeVersionTitle%, , Tools, Check Out...
  }
  else if WindowName = %UltraEditTitle%
  {
    files := GetUltraEditFile()
    CCCheckout(files)
  }
}
Return

;;
;;; handler for contextual menu
ShowCheckInMenu:
{
  ;; ContextMenuWindowName set by ContextMenu handler
  ShowCheckIn(ContextMenuWindowName)
}
Return
;;
;;; Call CheckIn
ShowCheckIn(WindowName)
{
  global ExplorerTitle, ClearCaseFindCheckoutTitle, ClearCaseHistoryTitle, ClearCaseExplorerTitle
  global ClearCaseTreeVersionTitle, UltraEditTitle

  if WindowName = %ExplorerTitle%
  {
    files := GetExplorerFilePath(WindowName)
    CCCheckin(files)
  }
  else if WindowName = %ClearCaseFindCheckoutTitle%
  {
    WinMenuSelectItem, %ClearCaseFindCheckoutTitle%, , Tools, Check In...
  }
  else if WindowName = %ClearCaseHistoryTitle%
  {
    files := GetHistoryFile()
    CCCheckin(files)
  }
  else if WindowName = %ClearCaseExplorerTitle%
  {
    ;; WinMenuSelectItem cannot be used with clearcase explorer like outlook, etc
    ;; Send message WM_COMMAND (0x111) to the clearcase explorer window
    ;; with 0x8005 wParam and 0 lParam (checkin in menu)
    PostMessage, 0x111, 32773, 0, , %ClearCaseExplorerTitle%
  }
  else if WindowName = %ClearCaseTreeVersionTitle%
  {
    WinMenuSelectItem, %ClearCaseTreeVersionTitle%, , Tools, Check In...
  }
  else if WindowName = %UltraEditTitle%
  {
    files := GetUltraEditFile()
    CCCheckin(files)
  }
}
Return

;;
;;; handler for contextual menu
ShowUnCheckOutMenu:
{
  ;; ContextMenuWindowName set by ContextMenu handler
  ShowUnCheckOut(ContextMenuWindowName)
}
Return
;;
;;; Call UnCheckOut
ShowUnCheckOut(WindowName)
{
  global ExplorerTitle, ClearCaseFindCheckoutTitle, ClearCaseHistoryTitle, ClearCaseExplorerTitle
  global ClearCaseTreeVersionTitle, UltraEditTitle

  if WindowName = %ExplorerTitle%
  {
    files := GetExplorerFilePath(WindowName)
    CCUncheckout(files)
  }
  else if WindowName = %ClearCaseFindCheckoutTitle%
  {
    WinMenuSelectItem, %ClearCaseFindCheckoutTitle%, , Tools, Undo Checkout...
  }
  else if WindowName = %ClearCaseHistoryTitle%
  {
    files := GetHistoryFile()
    CCUncheckout(files)
  }
  else if WindowName = %ClearCaseExplorerTitle%
  {
    ;; WinMenuSelectItem cannot be used with clearcase explorer like outlook, etc
    ;; Send message WM_COMMAND (0x111) to the clearcase explorer window
    ;; with 0x8011 wParam and 0 lParam (undo checkout in menu)
    PostMessage, 0x111, 32785, 0, , %ClearCaseExplorerTitle%
  }
  else if WindowName = %ClearCaseTreeVersionTitle%
  {
    WinMenuSelectItem, %ClearCaseTreeVersionTitle%, , Tools, Undo Checkout...
  }
  else if WindowName = %UltraEditTitle%
  {
    files := GetUltraEditFile()
    CCUncheckout(files)
  }
}
Return

;;
;;; handler for contextual menu
ShowHistoryMenu:
{
  ;; ContextMenuWindowName set by ContextMenu handler
  ShowHistory(ContextMenuWindowName)
}
Return
;;
;;; Call History
ShowHistory(WindowName)
{
  global ExplorerTitle, ClearCaseFindCheckoutTitle, ClearCaseHistoryTitle, ClearCaseExplorerTitle
  global ClearCaseTreeVersionTitle, UltraEditTitle

  if WindowName = %ExplorerTitle%
  {
    files := GetExplorerFilePath(WindowName)
    CCHistory(files)
  }
  else if WindowName = %ClearCaseFindCheckoutTitle%
  {
    WinMenuSelectItem, %ClearCaseFindCheckoutTitle%, , Tools, History
  }
  else if WindowName = %ClearCaseHistoryTitle%
  {
    files := GetHistoryFile()
    CCHistory(files)
  }
  else if WindowName = %ClearCaseExplorerTitle%
  {
    files := GetClearCaseExplorerFile()
    CCHistory(files)
  }
  else if WindowName = %ClearCaseTreeVersionTitle%
  {
    WinMenuSelectItem, %ClearCaseTreeVersionTitle%, , Tools, History
  }
  else if WindowName = %UltraEditTitle%
  {
    files := GetUltraEditFile()
    CCHistory(files)
  }
}
Return

;;
;;; handler for contextual menu
ShowComparePrevMenu:
{
  ;; ContextMenuWindowName set by ContextMenu handler
  ShowComparePrev(ContextMenuWindowName)
}
Return
;;
;;; Call ComparePrev
ShowComparePrev(WindowName)
{
  global ExplorerTitle, ClearCaseFindCheckoutTitle, ClearCaseHistoryTitle, ClearCaseExplorerTitle
  global ClearCaseTreeVersionTitle, UltraEditTitle

  if WindowName = %ExplorerTitle%
  {
    files := GetExplorerFilePath(WindowName)
    CCDiff(files)
  }
  else if WindowName = %ClearCaseFindCheckoutTitle%
  {
    WinMenuSelectItem, %ClearCaseFindCheckoutTitle%, , Tools, Compare with Previous Version
  }
  else if WindowName = %ClearCaseHistoryTitle%
  {
    WinMenuSelectItem, %ClearCaseHistoryTitle%, , Tools, Compare with Previous Version
  }
  else if WindowName = %ClearCaseExplorerTitle%
  {
    files := GetClearCaseExplorerFile()
    CCDiff(files)
  }
  else if WindowName = %ClearCaseTreeVersionTitle%
  {
    WinMenuSelectItem, %ClearCaseTreeVersionTitle%, , Tools, Compare, with Previous Version
  }
  else if WindowName = %UltraEditTitle%
  {
    files := GetUltraEditFile()
    CCDiff(files)
  }
}
Return

;;
;;; handler for contextual menu
ShowTreeVersionMenu:
{
  ;; ContextMenuWindowName set by ContextMenu handler
  ShowTreeVersion(ContextMenuWindowName)
}
Return
;;
;;; Call Tree Version
ShowTreeVersion(WindowName)
{
  global ExplorerTitle, ClearCaseFindCheckoutTitle, ClearCaseHistoryTitle, ClearCaseExplorerTitle
  global ClearCaseTreeVersionTitle, UltraEditTitle

  if WindowName = %ExplorerTitle%
  {
    files := GetExplorerFilePath(WindowName)
    CCTreeVersion(files)
  }
  else if WindowName = %ClearCaseFindCheckoutTitle%
  {
    WinMenuSelectItem, %ClearCaseFindCheckoutTitle%, , Tools, Version Tree
  }
  else if WindowName = %ClearCaseHistoryTitle%
  {
    WinMenuSelectItem, %ClearCaseHistoryTitle%, , Tools, Version Tree
  }
  else if WindowName = %ClearCaseExplorerTitle%
  {
    files := GetClearCaseExplorerFile()
    CCTreeVersion(files)
  }
  else if WindowName = %ClearCaseTreeVersionTitle%
  {
    ;; do only a refresh
    Send {F5}
  }
  else if WindowName = %UltraEditTitle%
  {
    files := GetUltraEditFile()
    CCTreeVersion(files)
  }
}
Return

;;
;;; handler for contextual menu
ShowExplorerMenu:
{
  ;; ContextMenuWindowName set by ContextMenu handler
  ShowExplorer(ContextMenuWindowName)
}
Return
;;
;;; Call ClearCase Explorer
ShowExplorer(WindowName)
{
  global ExplorerTitle, ClearCaseFindCheckoutTitle, ClearCaseHistoryTitle, ClearCaseExplorerTitle
  global ClearCaseTreeVersionTitle, UltraEditTitle
  global SoftwareName

  if WindowName = %ExplorerTitle%
  {
    dir := GetExplorerDirPath(WindowName)
    CCExplorer(dir)
  }
  else if WindowName = %ClearCaseFindCheckoutTitle%
  {
    dir := GetFindCheckoutsDir()
    CCExplorer(dir)
  }
  else if WindowName = %ClearCaseHistoryTitle%
  {
    dir := GetHistoryDir()
    CCExplorer(dir)
  }
  else if WindowName = %ClearCaseExplorerTitle%
  {
    dir := GetClearCaseExplorerDir()
    CCExplorer(dir)
  }
  else if WindowName = %ClearCaseTreeVersionTitle%
  {
    MsgBox, 0x10, %SoftwareName%, Cannot open ClearCase Explorer from Tree Version.
  }
  else if WindowName = %UltraEditTitle%
  {
    dir := GetUltraEditDir()
    CCExplorer(dir)
  }
}
Return

;;
;;; handler for contextual menu
ShowFindCheckoutMenu:
{
  ;; ContextMenuWindowName set by ContextMenu handler
  ShowFindCheckout(ContextMenuWindowName)
}
Return
;;
;;; Call Find Checkouts
ShowFindCheckout(WindowName)
{
  global ExplorerTitle, ClearCaseFindCheckoutTitle, ClearCaseHistoryTitle, ClearCaseExplorerTitle
  global ClearCaseTreeVersionTitle, UltraEditTitle
  global SoftwareName

  if WindowName = %ExplorerTitle%
  {
    dir := GetExplorerDirPath(WindowName)
    CCFindCheckout(dir)
  }
  else if WindowName = %ClearCaseFindCheckoutTitle%
  {
    dir := GetFindCheckoutsDir()
    CCFindCheckout(dir)
  }
  else if WindowName = %ClearCaseHistoryTitle%
  {
    dir := GetHistoryDir()
    CCFindCheckout(dir)
  }
  else if WindowName = %ClearCaseExplorerTitle%
  {
    dir := GetClearCaseExplorerDir()
    CCFindCheckout(dir)
  }
  else if WindowName = %ClearCaseTreeVersionTitle%
  {
    MsgBox, 0x10, %SoftwareName%, Cannot open ClearCase Find Checkout from Tree Version.
  }
  else if WindowName = %UltraEditTitle%
  {
    dir := GetUltraEditDir()
    CCFindCheckout(dir)
  }
}
Return

;;
;;; handler for contextual menu
ShowElementPropertiesMenu:
{
  ;; ContextMenuWindowName set by ContextMenu handler
  ShowElementProperties(ContextMenuWindowName)
}
Return
;;
;;; Call Element properties
ShowElementProperties(WindowName)
{
  global ExplorerTitle, ClearCaseFindCheckoutTitle, ClearCaseHistoryTitle, ClearCaseExplorerTitle
  global ClearCaseTreeVersionTitle, UltraEditTitle
  global SoftwareName

  if WindowName = %ExplorerTitle%
  {
    files := GetExplorerFilePath(WindowName)
    CCElementProperties(files)
  }
  else if WindowName = %ClearCaseFindCheckoutTitle%
  {
    files := GetFindCheckoutsSelectedFile()
    CCElementProperties(files)
  }
  else if WindowName = %ClearCaseHistoryTitle%
  {
    files := GetHistoryFile()
    CCElementProperties(files)
  }
  else if WindowName = %ClearCaseExplorerTitle%
  {
    files := GetClearCaseExplorerFile()
    CCElementProperties(files)
  }
  else if WindowName = %ClearCaseTreeVersionTitle%
  {
    MsgBox, 0x10, %SoftwareName%, Cannot open ClearCase Element Properties from Tree Version.
  }
  else if WindowName = %UltraEditTitle%
  {
    files := GetUltraEditFile()
    CCElementProperties(files)
  }
}
Return

;;
;;; handler for contextual menu
ShowVersionPropertiesMenu:
{
  ;; ContextMenuWindowName set by ContextMenu handler
  ShowVersionProperties(ContextMenuWindowName)
}
Return
;;
;;; Call Version properties
ShowVersionProperties(WindowName)
{
  global ExplorerTitle, ClearCaseFindCheckoutTitle, ClearCaseHistoryTitle, ClearCaseExplorerTitle
  global ClearCaseTreeVersionTitle, UltraEditTitle

  if WindowName = %ExplorerTitle%
  {
    files := GetExplorerFilePath(WindowName)
    CCVersionProperties(files)
  }
  else if WindowName = %ClearCaseFindCheckoutTitle%
  {
    WinMenuSelectItem, %ClearCaseFindCheckoutTitle%, , Tools, Properties
  }
  else if WindowName = %ClearCaseHistoryTitle%
  {
    WinMenuSelectItem, %ClearCaseHistoryTitle%, , Tools, Properties
  }
  else if WindowName = %ClearCaseExplorerTitle%
  {
    files := GetClearCaseExplorerFile()
    CCVersionProperties(files)
  }
  else if WindowName = %ClearCaseTreeVersionTitle%
  {
    WinMenuSelectItem, %ClearCaseTreeVersionTitle%, , Tools, Properties
  }
  else if WindowName = %UltraEditTitle%
  {
    files := GetUltraEditFile()
    CCVersionProperties(files)
  }
}
Return

;;
;;; handler for contextual menu
ShowAddToSourceControlMenu:
{
  ;; ContextMenuWindowName set by ContextMenu handler
  ShowAddToSourceControl(ContextMenuWindowName)
}
Return
;;
;;; Call Add to source control
ShowAddToSourceControl(WindowName)
{
  global ExplorerTitle, ClearCaseFindCheckoutTitle, ClearCaseHistoryTitle, ClearCaseExplorerTitle
  global ClearCaseTreeVersionTitle, UltraEditTitle
  global SoftwareName

  if WindowName = %ExplorerTitle%
  {
    files := GetExplorerFilePath(WindowName)
    CCAddToSourceControl(files)
  }
  else if WindowName = %ClearCaseFindCheckoutTitle%
  {
    MsgBox, 0x10, %SoftwareName%, Cannot add to source control a checkout file.
  }
  else if WindowName = %ClearCaseHistoryTitle%
  {
    MsgBox, 0x10, %SoftwareName%, Cannot add to source control a file with an history.
  }
  else if WindowName = %ClearCaseExplorerTitle%
  {
    ;; WinMenuSelectItem cannot be used with clearcase explorer like outlook, etc
    ;; Send message WM_COMMAND (0x111) to the clearcase explorer window
    ;; with 0x800E wParam and 0 lParam (add to source control in menu)
    PostMessage, 0x111, 32782, 0, , %ClearCaseExplorerTitle%
  }
  else if WindowName = %ClearCaseTreeVersionTitle%
  {
    MsgBox, 0x10, %SoftwareName%, Cannot add to source control a file with version.
  }
  else if WindowName = %UltraEditTitle%
  {
    files := GetUltraEditFile()
    CCAddToSourceControl(files)
  }
}
Return

;;
;;; handler for contextual menu
GetECSNumberMenu:
{
  ;; ContextMenuWindowName set by ContextMenu handler
  GetECSNumber(ContextMenuWindowName)
}
Return
;;
;;; Call get numero_ECS attribute
GetECSNUmber(WindowName)
{
  global ExplorerTitle, ClearCaseFindCheckoutTitle, ClearCaseHistoryTitle, ClearCaseExplorerTitle
  global ClearCaseTreeVersionTitle, UltraEditTitle
  global SoftwareName

  if WindowName = %ExplorerTitle%
  {
    files := GetExplorerFilePath(WindowName)
    CCGetECSNumber(files)
  }
  else if WindowName = %ClearCaseFindCheckoutTitle%
  {
    files := GetFindCheckoutsSelectedFile()
    CCGetECSNumber(files)
  }
  else if WindowName = %ClearCaseHistoryTitle%
  {
    files := GetHistoryFile()
    CCGetECSNumber(files)
  }
  else if WindowName = %ClearCaseExplorerTitle%
  {
    files := GetClearCaseExplorerSelectedFile()
    CCGetECSNumber(files)
  }
  else if WindowName = %ClearCaseTreeVersionTitle%
  {
    MsgBox, 0x10, %SoftwareName%, Cannot get numero_ECS attributes.
  }
  else if WindowName = %UltraEditTitle%
  {
    files := GetUltraEditFile()
    CCGetECSNumber(files)
  }
}
Return

;;
;;; handler for edit config spec contextual menu
EditConfigSpecMenu:
{
  ;; get path of current directory
  EditConfigSpecDirPath := GetDirectoryPath(ContextMenuWindowName)
  ;; edit and apply config-spec
  CCEditConfigSpec(EditConfigSpecDirPath)
}

;;
;;; Get active window identifier
GetActiveWindowName()
{
  global ExplorerTitle, ClearCaseFindCheckoutTitle, ClearCaseHistoryTitle, ClearCaseExplorerTitle
  global ClearCaseTreeVersionTitle, UltraEditTitle

  ;; detect active window
  ifWinActive, %ExplorerTitle%
  {
    WindowName = %ExplorerTitle%
  }
  else ifWinActive, %ClearCaseFindCheckoutTitle%
  {
    WindowName = %ClearCaseFindCheckoutTitle%
  }
  else ifWinActive, %ClearCaseHistoryTitle%
  {
    WindowName = %ClearCaseHistoryTitle%
  }
  else ifWinActive, %ClearCaseExplorerTitle%
  {
    WindowName = %ClearCaseExplorerTitle%
  }
  else ifWinActive, %ClearCaseTreeVersionTitle%
  {
    WindowName = %ClearCaseTreeVersionTitle%
  }
  else ifWinActive, %UltraEditTitle%
  {
    WindowName = %UltraEditTitle%
  }
  else
  {
    WindowName = ""
  }

  Return WindowName
}

;;
;;; Get directory path of current path
GetDirectoryPath(WindowName)
{
  global ExplorerTitle, ClearCaseFindCheckoutTitle, ClearCaseHistoryTitle, ClearCaseExplorerTitle
  global ClearCaseTreeVersionTitle, UltraEditTitle
  global SoftwareName

  if WindowName = %ExplorerTitle%
  {
    dirPath := GetExplorerDirPath(WindowName)
  }
  else if WindowName = %ClearCaseFindCheckoutTitle%
  {
    dirPath := GetFindCheckoutsDir()
  }
  else if WindowName = %ClearCaseHistoryTitle%
  {
    dirPath := GetHistoryDir()
  }
  else if WindowName = %ClearCaseExplorerTitle%
  {
    dirPath := GetClearCaseExplorerDir()
  }
  else if WindowName = %ClearCaseTreeVersionTitle%
  {
    MsgBox, 0x10, %SoftwareName%, Cannot edit config-spec from Tree Version.
    dirPath := ""
  }
  else if WindowName = %UltraEditTitle%
  {
    dirPath := GetUltraEditDir()
  }

  if StrLen(dirPath)
  {
    ;; to remove ""
    StringTrimLeft, dirPath, dirPath, 1
    StringTrimRight, dirPath, dirPath, 1
  }

  Return dirPath
}

;
;;
;;; CLEARCASE
;===============================================================================
;;
;;; show checkout window about selected file
CCCheckout(files)
{
  if StrLen(files)
  {
    Run, cleardlg.exe /window 5061e /windowmsg A065 /checkout %files%
  }
}
Return

;;
;;; show checkin window about selected file
CCCheckin(files)
{
  if StrLen(files)
  {
    Run, cleardlg.exe /window 606f6 /windowmsg A065 /checkin %files%
  }
}
Return

;;
;;; show uncheckout window about selected file
CCUncheckout(files)
{
  if StrLen(files)
  {
    Run, cleardlg.exe /window c04ca /windowmsg A065 /uncheckout %files%
  }
}
Return

;;
;;; show history about selected file
CCHistory(files)
{
  if StrLen(files)
  {
    ;; split with space
    StringSplit, arrayFiles, files, %A_Space%
    ;; browse array
    Loop %arrayFiles0%
    {
      ;; get the file
      file := arrayFiles%A_Index%
      Run, clearhistory.exe %file%
    }
  }
}
Return

;;
;;; show diff with previous file about selected file
CCDiff(files)
{
  if StrLen(files)
  {
    ;; split with space
    StringSplit, arrayFiles, files, %A_Space%
    ;; browse array
    Loop %arrayFiles0%
    {
      ;; get the file
      file := arrayFiles%A_Index%
      Run, cleartool.exe diff -graphical -predecessor %file%
    }
  }
}
Return

;;
;;; show tree version about selected file
CCTreeVersion(files)
{
  if StrLen(files)
  {
     ;; split with space
    StringSplit, arrayFiles, files, %A_Space%
    ;; browse array
    Loop %arrayFiles0%
    {
      ;; get the file
      file := arrayFiles%A_Index%
      Run, clearvtree.exe %file%
    }
  }
}
Return

;;
;;; show explorer about selected file
CCExplorer(dirPath)
{
  if StrLen(dirPath)
  {
    Run, clearexplorer.exe "%dirPath%"
  }
}
Return

;;
;;; show find checkout about selected file
CCFindCheckout(dirPath)
{
  if StrLen(dirPath)
  {
    Run, clearfindco.exe "%dirPath%"
  }
}
Return

;;
;;; show element properties about selected file
CCElementProperties(files)
{
  if StrLen(files)
  {
    ;; split with space
    StringSplit, arrayFiles, files, %A_Space%
    ;; browse array
    Loop %arrayFiles0%
    {
      ;; get the file
      file := arrayFiles%A_Index%
      ;; to remove " end
      StringTrimRight, file, file, 1
      Run, cleardescribe.exe %file%@@`"
    }
  }
}
Return

;;
;;; show version properties about selected file
CCVersionProperties(files)
{
  if StrLen(files)
  {
    ;; split with space
    StringSplit, arrayFiles, files, %A_Space%
    ;; browse array
    Loop %arrayFiles0%
    {
      ;; get the file
      file := arrayFiles%A_Index%
      Run, cleardescribe.exe %file%
    }
  }
}
Return

;;
;;; show version properties about selected file
CCAddToSourceControl(files)
{
  if StrLen(files)
  {
    Run, cleardlg.exe /window 30324 /windowmsg A065 /addtosrc %files%
  }
}
Return

;;
;;; copy to clipboard the ECS number about selected file
CCGetECSNumber(files)
{
  global SoftwareName, SedCommand, GclipCommand

  if StrLen(files)
  {
    ;; init ecs number to set in clipboard
    ecsNumber :=  ""
    ;; split with "
    StringSplit, arrayFiles, files, %A_Space%
    ;; browse array
    Loop %arrayFiles0%
    {
      ;; get the file
      file := arrayFiles%A_Index%
      ;; to remove " end
      StringTrimRight, file, file, 1
      clipSaved = %Clipboard%
      ;; get the attribute value between "   |   remove "" with sed   |   send to clipboard
      RunWait, %comspec% /c "cleartool.exe describe -fmt "`%NS[numero_ECS]a" %file%@@`" | "%SedCommand%" "s/^\"\(.*\)\"$/\1/" | "%GclipCommand%""
      if Clipboard != %clipSaved%
      {
        ;; concat the clipboard result
        ecsNumber = %ecsNumber%%A_Space%%Clipboard%
        ;; empty the clipboard
        Clipboard =
      }
    }

    if StrLen(ecsNumber)
    {
      ;; set the clipboard with concat ecs number
      Clipboard = %ecsNumber%

      ;; display successful of copy ECS number
      TrayTip, %SoftwareName%, numero_ECS attribute `"%ecsNumber%`" to clipboard., 5, 1
    }
    else
    {
      ;; display error of copy ECS number
      TrayTip, %SoftwareName%, cannot get numero_ECS attribute., 5, 1
    }
  }
}
Return

;;
;;; get config-spec and edit it
CCEditConfigSpec(dirPath)
{
  global ConfigSpecEditorCommand, ConfigSpecFileName, SoftwareName

  if StrLen(dirPath)
  {
    ;; set absolute file path
    fileName = % dirPath . "\" . ConfigSpecFileName

    ;; get config spec
    RunWait, %comspec% /c "cd %dirPath% && cleartool.exe catcs > %ConfigSpecFileName%", %dirPath%

    ;; launch default editor
    Run, %fileName%, %dirPath%, UseErrorLevel, editorPID
    if ErrorLevel = ERROR
    {
       Run, notepad %ConfigSpecFileName%, %dirPath%, UseErrorLevel, editorPID
       if ErrorLevel = ERROR
       {
         FileDelete, %fileName%
         MsgBox, 0x10, %SoftwareName%, notepad not found.
         Return
       }
    }
    ;; can detect hidden window
    DetectHiddenWindows, On
    ;; wait editor
    WinWait, ahk_pid %editorPID%

    ;; init loop
    ;; get the file time of modification of file (for reference)
    FileGetTime, CurrentDate, %fileName%, M
    FileTime = %CurrentDate%
    ;; while the modification time reference is the same as the current
    ;; modification time
    While (FileTime = CurrentDate)
    {
      ;; get modification time of temporary file
      FileGetTime, FileTime, %fileName%, M
      ;; when editor is not running
      IfWinNotExist, ahk_pid %editorPID%
      {
        ;; display tray tip to indicate of no change of config spec
        TrayTip, %SoftwareName%, config-spec has not changed., 5, 1
        break
      }
      ;; wait 100ms (pooling)
      Sleep, 100
    }

    ;; cannot detect hidden window
    DetectHiddenWindows, Off

    if (FileTime != CurrentDate)
    {
      ;; get config spec
      RunWait, %comspec% /c "cd %dirPath% && cleartool.exe setcs %ConfigSpecFileName%", %dirPath%
      ;; display tray tip to indicate setting of config spec
      TrayTip, %SoftwareName%, setting config-spec done., 5, 1
    }
    ;; to be sure it is not used after wait clearcase setcs
    sleep, 100
    ;; delete temp file
    FileDelete, %fileName%
  }
}
Return

;
;;
;;; TRAY ICON MENU HANDLER
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
        %MainKey%   %CheckOutShortcut%`t`tCheck Out...
        %MainKey%   %CheckInShortcut%`t`tCheck In...
        %MainKey%   %UnCheckOutShortcut%`t`tUn Checkout...
        %MainKey%   %HistoryShortcut%`t`tHistory
        %MainKey%   %ComparePrevShortcut%`t`tCompare with Previous Version
        %MainKey%   %TreeVersionShortcut%`t`Version Tree
        %MainKey%   %ExplorerShortcut%`t`tClearCase Explorer `(not working in CC Tree Version`)
        %MainKey%   %FindCheckoutShortcut%`t`tFind Checkouts `(not working in CC Tree Version`)
        %MainKey%   %ElementPropertiesShortcut%`t`tProperties of Element `(not working in CC Tree Version`)
        %MainKey%   %VersionPropertiesShortcut%`t`tProperties of Version
        %MainKey%   %AddToSourceControlShortcut%`t`tAdd to Source Control (only on a View-private file)
        %MainKey%   %GetECSNumberShortcut%`t`tCopy numero_ECS attribute
        %MainKey%   %EditConfigSpecShortcut%`t`tEdit Config Spec `(not working in CC Tree Version`)
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
  ;; title group if change
  CreateGroupTitle()

  if (ContextMenu_OK)
  {
    ;; to reload menu
    ContextMenu_OK := False
    ;; delete all entry in menu
    Menu, Context_, DeleteAll
  }
Return


;
;;
;;; OPTIONS GUI
;===============================================================================
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
  ;; frame with title (w270 = 15 + 110 + 10 + 145 + 15)
  Gui, Options_:Add, GroupBox, x10 W270 h325, Shortcuts
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
  ;; label for add to source control shortcut
  Gui, Options_:Add, Text, xs w%labelWidth% Section, Add to Source Control:
  ;; add a edit area to enter hotkey for add to source control shortcut
  Gui, Options_:Add, Hotkey, ys-4 vKeyAddToSourceControl, %AddToSourceControlShortcut%
  ;; label for add to copy numero_ECS attribute shortcut
  Gui, Options_:Add, Text, xs w%labelWidth% Section, Copy numero_ECS:
  ;; add a edit area to enter hotkey for add to copy numero_ECS attribute shortcut
  Gui, Options_:Add, Hotkey, ys-4 vKeyGetECSNumber, %GetECSNumberShortcut%
  ;; label for edit config spec shortcut
  Gui, Options_:Add, Text, xs w%labelWidth% Section, Edit config-spec:
  ;; add a edit area to enter hotkey for edit config spec shortcut
  Gui, Options_:Add, Hotkey, ys-4 vKeyEditConfigSpec, %EditConfigSpecShortcut%
  ;;
  ;; frame with title for contextual menu
  Gui, Options_:Add, GroupBox, x10 W270 h45, Contextual Menu
  ;; checkbox for contextual menu, checked depends on ContextMenuEnable variable
  Gui, Options_:Add, CheckBox, xp+15 yp+19 Section Checked%ContextMenuEnable% vContextMenuCheck, Enable contextual menu
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
  GuiControlGet, ContextMenuCheck
  ;; remove the gui
  Gui, Destroy
  ;; enable/disable contextual menu
  If ContextMenuCheck = 1
  {
    Hotkey, IfWinActive, ahk_group %GroupWindowTitle%
    ;; enable clearcase shortcut contextual menu
    Hotkey, $RButton, RightClickButton
    Hotkey, $RButton Up, RightClickUpButton
    Hotkey, IfWinActive
    ContextMenuEnable := 1
  }
  else
  {
    Hotkey, IfWinActive, ahk_group %GroupWindowTitle%
    ;; disable clearcase shortcut contextual menu
    Hotkey, $RButton, RightClickButton, Off
    Hotkey, $RButton Up, RightClickUpButton, Off
    ;; enable key for others
    Hotkey, $RButton, , On
    Hotkey, $RButton Up, , On
    Hotkey, IfWinActive
    ContextMenuEnable := 0
  }
  ;; when the checkbox window key is checked
  If WindowKey = 1
  {
    ;; prefix shortcut with #
    Key = % "#" Key
  }
  ;; unset previous shortcut for window
  Hotkey, IfWinActive, ahk_group %GroupWindowTitle%
  HotKey, %MainShortcut%, CheckShortcut, Off
  Hotkey, IfWinActive
  ;; when key already exist
  HotKey, %Key%, , UseErrorLevel
  If ErrorLevel = 6
  {
    ;; enable new shortcut
    Hotkey, IfWinActive, ahk_group %GroupWindowTitle%
    HotKey, %Key%, , On
    Hotkey, IfWinActive
  }
  ;; set new shortcut for window
  Hotkey, IfWinActive, ahk_group %GroupWindowTitle%
  HotKey, %Key%, CheckShortcut
  Hotkey, IfWinActive
  ;; set new shortcut and write in ini file
  MainShortcut = %Key%
  GoSub, MenuCreateSaveIni
Return

;;
;;; each time I want to create a group of window, I increment the name of the
;;; group because ahk cannot delete group
CreateGroupTitle()
{
  global GroupWindowTitle, ExplorerTitle, ClearCaseFindCheckoutTitle, ClearCaseHistoryTitle
  global ClearCaseExplorerTitle, ClearCaseTreeVersionTitle, UltraEditTitle

  static groupIndex := 1

  ;; increment name
  GroupWindowTitle := "GroupWindowTitle" groupIndex++

  ;; create group
  GroupAdd, %GroupWindowTitle%, %ExplorerTitle%
  GroupAdd, %GroupWindowTitle%, %ClearCaseFindCheckoutTitle%
  GroupAdd, %GroupWindowTitle%, %ClearCaseHistoryTitle%
  GroupAdd, %GroupWindowTitle%, %ClearCaseExplorerTitle%
  GroupAdd, %GroupWindowTitle%, %ClearCaseTreeVersionTitle%
  GroupAdd, %GroupWindowTitle%, %UltraEditTitle%
}
Return

;
;;
;;; INI
;===============================================================================
;;
;;; load all setting from ini file if they exist otherwise default value
LoadIniFile:
  ;; shortcuts
  IniRead, MainShortcut,               %IniFile%, Shortcut, MainShortcut,               #c
  IniRead, CheckOutShortcut,           %IniFile%, Shortcut, CheckOutShortcut,           c
  IniRead, CheckInShortcut,            %IniFile%, Shortcut, CheckInShortcut,            i
  IniRead, UnCheckOutShortcut,         %IniFile%, Shortcut, UnCheckOutShortcut,         u
  IniRead, HistoryShortcut,            %IniFile%, Shortcut, HistoryShortcut,            h
  IniRead, ComparePrevShortcut,        %IniFile%, Shortcut, ComparePrevShortcut,        =
  IniRead, TreeVersionShortcut,        %IniFile%, Shortcut, TreeVersionShortcut,        t
  IniRead, ExplorerShortcut,           %IniFile%, Shortcut, ExplorerShortcut,           e
  IniRead, FindCheckoutShortcut,       %IniFile%, Shortcut, FindCheckoutShortcut,       f
  IniRead, ElementPropertiesShortcut,  %IniFile%, Shortcut, ElementPropertiesShortcut,  p
  IniRead, VersionPropertiesShortcut,  %IniFile%, Shortcut, VersionPropertiesShortcut,  v
  IniRead, AddToSourceControlShortcut, %IniFile%, Shortcut, AddToSourceControlShortcut, a
  IniRead, GetECSNumberShortcut,       %IniFile%, Shortcut, GetECSNumberShortcut,       n
  IniRead, EditConfigSpecShortcut,     %IniFile%, Shortcut, EditConfigSpecShortcut,     s
  ;;
  ;; window titles
  IniRead, ExplorerTitle,              %IniFile%, Title, ExplorerTitle, ahk_class CabinetWClass|ExploreWClass
  IniRead, ClearCaseFindCheckoutTitle, %IniFile%, Title, ClearCaseFindCheckoutTitle, Find Checkouts ahk_exe clearfindco.exe
  IniRead, ClearCaseHistoryTitle,      %IniFile%, Title, ClearCaseHistoryTitle, Rational ClearCase History Browser - ahk_exe clearhistory.exe
  IniRead, ClearCaseExplorerTitle,     %IniFile%, Title, ClearCaseExplorerTitle, Rational ClearCase Explorer - ahk_exe clearexplorer.exe
  IniRead, ClearCaseTreeVersionTitle,  %IniFile%, Title, ClearCaseTreeVersionTitle, ahk_exe clearvtree.exe
  IniRead, UltraEditTitle,             %IniFile%, Title, UltraEditTitle, ahk_exe uedit32.exe
  ;; contextual menu
  IniRead, ContextMenuTime,                    %IniFile%, ContextMenu, ContextMenuTime, 300
  IniRead, ContextMenuEnable,                  %IniFile%, ContextMenu, ContextMenuEnable, 1
  IniRead, ContextMenuMax,                     %IniFile%, ContextMenu, ContextMenuMax,                     18
  IniRead, ContextMenuPlaceExplorer,           %IniFile%, ContextMenu, ContextMenuPlaceExplorer,           0
  IniRead, ContextMenuPlaceFindCheckout,       %IniFile%, ContextMenu, ContextMenuPlaceFindCheckout,       2
  IniRead, ContextMenuPlaceCheckOut,           %IniFile%, ContextMenu, ContextMenuPlaceCheckOut,           4
  IniRead, ContextMenuPlaceCheckIn,            %IniFile%, ContextMenu, ContextMenuPlaceCheckIn,            5
  IniRead, ContextMenuPlaceUnCheckOut,         %IniFile%, ContextMenu, ContextMenuPlaceUnCheckOut,         6
  IniRead, ContextMenuPlaceAddToSourceControl, %IniFile%, ContextMenu, ContextMenuPlaceAddToSourceControl, 7
  IniRead, ContextMenuPlaceHistory,            %IniFile%, ContextMenu, ContextMenuPlaceHistory,            9
  IniRead, ContextMenuPlaceTreeVersion,        %IniFile%, ContextMenu, ContextMenuPlaceTreeVersion,        10
  IniRead, ContextMenuPlaceComparePrev,        %IniFile%, ContextMenu, ContextMenuPlaceComparePrev,        11
  IniRead, ContextMenuPlacePropertiesVersion,  %IniFile%, ContextMenu, ContextMenuPlacePropertiesVersion,  13
  IniRead, ContextMenuPlacePropertiesElement,  %IniFile%, ContextMenu, ContextMenuPlacePropertiesElement,  14
  IniRead, ContextMenuPlaceGetECSNumber,       %IniFile%, ContextMenu, ContextMenuPlaceGetECSNumber,       15
  IniRead, ContextMenuPlaceEditConfigSpec,     %IniFile%, ContextMenu, ContextMenuPlaceEditConfigSpec,     17
  ;; config spec
  IniRead, ConfigSpecFileName, %IniFile%, ConfigSpec, ConfigSpecFileName, clearcaseshortcut-config-spec.cs
  ;; command
  IniRead, SedCommand,   %IniFile%, Command, SedCommand, M:\livraison_agl\agl\liv\outils\win32\UnxUtils\sed.exe
  IniRead, GclipCommand, %IniFile%, Command, GclipCommand, M:\livraison_agl\agl\liv\outils\win32\UnxUtils\gclip.exe
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
  IniWrite, %MainShortcut%,               %IniFile%, Shortcut, MainShortcut
  IniWrite, %CheckOutShortcut%,           %IniFile%, Shortcut, CheckOutShortcut
  IniWrite, %CheckInShortcut%,            %IniFile%, Shortcut, CheckInShortcut
  IniWrite, %UnCheckOutShortcut%,         %IniFile%, Shortcut, UnCheckOutShortcut
  IniWrite, %HistoryShortcut%,            %IniFile%, Shortcut, HistoryShortcut
  IniWrite, %ComparePrevShortcut%,        %IniFile%, Shortcut, ComparePrevShortcut
  IniWrite, %TreeVersionShortcut%,        %IniFile%, Shortcut, TreeVersionShortcut
  IniWrite, %ExplorerShortcut%,           %IniFile%, Shortcut, ExplorerShortcut
  IniWrite, %FindCheckoutShortcut%,       %IniFile%, Shortcut, FindCheckoutShortcut
  IniWrite, %ElementPropertiesShortcut%,  %IniFile%, Shortcut, ElementPropertiesShortcut
  IniWrite, %VersionPropertiesShortcut%,  %IniFile%, Shortcut, VersionPropertiesShortcut
  IniWrite, %AddToSourceControlShortcut%, %IniFile%, Shortcut, AddToSourceControlShortcut
  IniWrite, %GetECSNumberShortcut%,       %IniFile%, Shortcut, GetECSNumberShortcut
  IniWrite, %EditConfigSpecShortcut%,     %IniFile%, Shortcut, EditConfigSpecShortcut
  ;; Section Title
  IniWrite, %ExplorerTitle%,              %IniFile%, Title, ExplorerTitle
  IniWrite, %ClearCaseFindCheckoutTitle%, %IniFile%, Title, ClearCaseFindCheckoutTitle
  IniWrite, %ClearCaseHistoryTitle%,      %IniFile%, Title, ClearCaseHistoryTitle
  IniWrite, %ClearCaseExplorerTitle%,     %IniFile%, Title, ClearCaseExplorerTitle
  IniWrite, %ClearCaseTreeVersionTitle%,  %IniFile%, Title, ClearCaseTreeVersionTitle
  IniWrite, %UltraEditTitle%,             %IniFile%, Title, UltraEditTitle
  ;; Section Contextual Menu
  IniWrite, %ContextMenuTime%,                    %IniFile%, ContextMenu, ContextMenuTime
  IniWrite, %ContextMenuEnable%,                  %IniFile%, ContextMenu, ContextMenuEnable
  IniWrite, %ContextMenuMax%,                     %IniFile%, ContextMenu, ContextMenuMax
  IniWrite, %ContextMenuPlaceExplorer%,           %IniFile%, ContextMenu, ContextMenuPlaceExplorer
  IniWrite, %ContextMenuPlaceFindCheckout%,       %IniFile%, ContextMenu, ContextMenuPlaceFindCheckout
  IniWrite, %ContextMenuPlaceCheckOut%,           %IniFile%, ContextMenu, ContextMenuPlaceCheckOut
  IniWrite, %ContextMenuPlaceCheckIn%,            %IniFile%, ContextMenu, ContextMenuPlaceCheckIn
  IniWrite, %ContextMenuPlaceUnCheckOut%,         %IniFile%, ContextMenu, ContextMenuPlaceUnCheckOut
  IniWrite, %ContextMenuPlaceAddToSourceControl%, %IniFile%, ContextMenu, ContextMenuPlaceAddToSourceControl
  IniWrite, %ContextMenuPlaceHistory%,            %IniFile%, ContextMenu, ContextMenuPlaceHistory
  IniWrite, %ContextMenuPlaceTreeVersion%,        %IniFile%, ContextMenu, ContextMenuPlaceTreeVersion
  IniWrite, %ContextMenuPlaceComparePrev%,        %IniFile%, ContextMenu, ContextMenuPlaceComparePrev
  IniWrite, %ContextMenuPlacePropertiesVersion%,  %IniFile%, ContextMenu, ContextMenuPlacePropertiesVersion
  IniWrite, %ContextMenuPlacePropertiesElement%,  %IniFile%, ContextMenu, ContextMenuPlacePropertiesElement
  IniWrite, %ContextMenuPlaceGetECSNumber%,       %IniFile%, ContextMenu, ContextMenuPlaceGetECSNumber
  IniWrite, %ContextMenuPlaceEditConfigSpec%,     %IniFile%, ContextMenu, ContextMenuPlaceEditConfigSpec
  ;; Section Config Spec
  IniWrite, %ConfigSpecFileName%, %IniFile%, ConfigSpec, ConfigSpecFileName
  ;; Section Command
  IniWrite, %SedCommand%,   %IniFile%, Command, SedCommand
  IniWrite, %GclipCommand%, %IniFile%, Command, GclipCommand
  ;;
  ;; display a traytip to indicate file save
  TrayTip, %SoftwareName%, %IniFile% file saved., 5, 1
Return
