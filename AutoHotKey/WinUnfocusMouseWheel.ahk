#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; MENU                                                                       ;;
;; {                                                                          ;;
Menu, TRAY, Icon, WinUnfocusMouseWheel.ico
;; } /* MENU */                                                               ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

CoordMode, Mouse, Screen
return

WheelUp::
   MouseGetPos, m_x, m_y
   hw_m_target := DllCall( "WindowFromPoint", "int", m_x, "int", m_y )

  ; WM_MOUSEWHEEL
  ;   WHEEL_DELTA = 120
  SendMessage, 0x20A, 120 << 16, ( m_y << 16 )|m_x,, ahk_id %hw_m_target%
return

WheelDown::
   MouseGetPos, m_x, m_y
   hw_m_target := DllCall( "WindowFromPoint", "int", m_x, "int", m_y )

   ; WM_MOUSEWHEEL
   ;   WHEEL_DELTA = 120
   SendMessage, 0x20A, -120 << 16, ( m_y << 16 )|m_x,, ahk_id %hw_m_target%
return
