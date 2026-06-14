#Requires AutoHotkey v2.0
#SingleInstance Force

SetWorkingDir A_InitialWorkingDir

ProcessSetPriority "Realtime"     ; Forces Windows kernel to prioritize hotkey intercepts
A_MaxHotkeysPerInterval := 200     ; Prevents AHK warning flags during rapid layout shifts
ListLines 0                       ; Disables line logging in memory to squeeze out maximum execution speed
SendMode "Input"                  ; Forces raw Windows input stream injection for zero-latency typing

;          _             _                _            _            _       _    _          _            _              _    _        _   
;        / /\          /\_\             /\ \         /\ \         / /\    / /\ /\ \       /\ \         /\_\           /\ \ /\ \     /\_\ 
;       / /  \        / / /         _   \_\ \       /  \ \       / / /   / / //  \ \      \_\ \       / / /  _       /  \ \\ \ \   / / / 
;      / / /\ \       \ \ \__      /\_\ /\__ \     / /\ \ \     / /_/   / / // /\ \ \     /\__ \     / / /  /\_\    / /\ \ \\ \ \_/ / /  
;     / / /\ \ \       \ \___\    / / // /_ \ \   / / /\ \ \   / /\ \__/ / // / /\ \ \   / /_ \ \   / / /__/ / /   / / /\ \_\\ \___/ /   
;    / / /  \ \ \       \__  /   / / // / /\ \ \ / / /  \ \_\ / /\ \___\/ // / /  \ \_\ / / /\ \ \ / /\_____/ /   / /_/_ \/_/ \ \ \_/    
;   / / /___/ /\ \      / / /   / / // / /  \/_// / /   / / // / /\/___/ // / /   / / // / /  \/_// /\_______/   / /____/\     \ \ \     
;  / / /_____/ /\ \    / / /   / / // / /      / / /   / / // / /   / / // / /   / / // / /      / / /\ \ \     / /\____\/      \ \ \    
; / /_________/\ \ \  / / /___/ / // / /      / / /___/ / // / /   / / // / /___/ / // / /      / / /  \ \ \   / / /______       \ \ \   
;/ / /_       __\ \_\/ / /____\/ //_/ /      / / /____\/ // / /   / / // / /____\/ //_/ /      / / /    \ \ \ / / /_______\       \ \_\  
;\_\___\     /____/_/\/_________/ \_\/       \/_________/ \/_/    \/_/ \/_________/ \_\/       \/_/      \_\_\\/__________/        \/_/  
;                                                                                                                                        

; • HYPRLAND MOUSE RESIZE

; • HYPRLAND MOUSE RESIZE (TRUE 8-ZONE DIRECTIONAL GRID)

+RButton::
{
    MouseGetPos(&mX, &mY, &WindowID)
    if !WindowID
        return
    WinGetPos(&wX, &wY, &wW, &wH, "ahk_id " WindowID)
    WinActivate("ahk_id " WindowID)
    
    ; Calculate mouse coordinates relative to the active window geometry
    relX := mX - wX
    relY := mY - wY
    
    ; Define edge threshold buffers (25% of window size for responsive targeting)
    EdgeX := wW / 4
    EdgeY := wH / 4
    
    ; Determine horizontal position zone
    isLeft  := (relX < EdgeX)
    isRight := (relX > wW - EdgeX)
    
    ; Determine vertical position zone
    isTop    := (relY < EdgeY)
    isBottom := (relY > wH - EdgeY)
    
    ; --- 8-ZONE VECTOR INTERCEPT ROUTING ---
    if (isTop && isLeft) {
        PostMessage(0x0112, 0xF004, 0, , "ahk_id " WindowID)  ; Top-Left Corner
    } else if (isTop && isRight) {
        PostMessage(0x0112, 0xF005, 0, , "ahk_id " WindowID)  ; Top-Right Corner
    } else if (isBottom && isLeft) {
        PostMessage(0x0112, 0xF007, 0, , "ahk_id " WindowID)  ; Bottom-Left Corner
    } else if (isBottom && isRight) {
        PostMessage(0x0112, 0xF008, 0, , "ahk_id " WindowID)  ; Bottom-Right Corner
    } else if (isTop) {
        PostMessage(0x0112, 0xF003, 0, , "ahk_id " WindowID)  ; Top Edge Only
    } else if (isBottom) {
        PostMessage(0x0112, 0xF006, 0, , "ahk_id " WindowID)  ; Bottom Edge Only
    } else if (isLeft) {
        PostMessage(0x0112, 0xF001, 0, , "ahk_id " WindowID)  ; Left Edge Only
    } else if (isRight) {
        PostMessage(0x0112, 0xF002, 0, , "ahk_id " WindowID)  ; Right Edge Only
    }
    
    KeyWait "RButton"      ; Keep tracking thread locked until right click release
    Click "Left Up"        ; Force a drop sequence to snap the tiling alignment
}


; • HIGH-SPEED DAEMON PIPE INJECTION 

KCmd(command) {
    ; Connects directly to Komorebi's core memory pipe, bypassing file execution overhead entirely
    if (pipe := DllCall("CreateFile", "Str", "\\.\pipe\komorebi", "UInt", 0x40000000, "UInt", 0, "Ptr", 0, "UInt", 3, "UInt", 0, "Ptr", 0, "Ptr")) != -1 {
        DllCall("WriteFile", "Ptr", pipe, "AStr", command, "UInt", StrLen(command), "UInt*", 0, "Ptr", 0)
        DllCall("CloseHandle", "Ptr", pipe)
    } else {
        ; Fallback to direct shell execution if daemon connection is busy
        Run("komorebic.exe " command, , "Hide")
    }
}


; • SYSTEM & RELOAD

!o::Reload()                                            
!+o::KCmd("reload-configuration")    


; • APPS

#Enter::Run("wt")  ;Win + Enter: Windows Terminal (Classic Linux Feel)
!+z::Run("C:\Program Files\Zen\zen.exe")
!+c::RUN("C:\Program Files\cursor\cursor.exe")


; • WINDOW MANAGEMENT

!+q::KCmd("close")
!+m::KCmd("minimize")
!f::
{
    KCmd("toggle-float")
    
    ; Grab the handle of the monitor containing the mouse pointer
    MonitorNum := DllCall("User32\MonitorFromPoint", "Int64", 0, "UInt", 2)
    
    ; Get workspace coordinates (excludes the Windows taskbar/YASB space)
    NumPut("UInt", 40, buf := Buffer(40))
    DllCall("User32\GetMonitorInfo", "Ptr", MonitorNum, "Ptr", buf)
    
    wLeft   := NumGet(buf, 20, "Int")
    wTop    := NumGet(buf, 24, "Int")
    wRight  := NumGet(buf, 28, "Int")
    wBottom := NumGet(buf, 32, "Int")
    wWidth  := wRight - wLeft
    wHeight := wBottom - wTop

    WinGetPos(,, &wW, &wH, "A")
    ; Perfectly center the floating window inside the current working area across all screen arrays
    WinMove(wLeft + (wWidth/2) - (wW/2), wTop + (wHeight/2) - (wH/2),,, "A")
}


; • FOCUS WINDOWS

!Left::KCmd("focus left")
!Down::KCmd("focus down")
!Up::KCmd("focus up")
!Right::KCmd("focus right")
!+[::KCmd("cycle-focus previous")
!+]::KCmd("cycle-focus next")


; • MOVE WINDOWS

!+Left::KCmd("move left")
!+Down::KCmd("move down")
!+Up::KCmd("move up")
!+Right::KCmd("move right")
!+Enter::KCmd("promote")


; • RESIZE WINDOWS (AXIS)

!=::KCmd("resize-axis horizontal increase")
!-::KCmd("resize-axis horizontal decrease")
!+=::KCmd("resize-axis vertical increase")
!+-::KCmd("resize-axis vertical decrease")


; • LAYOUTS

!x::KCmd("flip-layout horizontal")
!y::KCmd("flip-layout vertical")
!+x::KCmd("cycle-layout next")
!+y::KCmd("cycle-layout previous")
!+f::KCmd("toggle-monocle")
!q::KCmd("retile")
!p::KCmd("toggle-pause")


; • FOCUS WORKSPACES (0-7)

!1::KCmd("focus-workspace 0")
!2::KCmd("focus-workspace 1")
!3::KCmd("focus-workspace 2")
!4::KCmd("focus-workspace 3")
!5::KCmd("focus-workspace 4")
!6::KCmd("focus-workspace 5")
!7::KCmd("focus-workspace 6")
!8::KCmd("focus-workspace 7")


; Yasb Logic

!.::Run("yasbc start", , "Hide")
!,::Run("yasbc stop", , "Hide")
!/::Run("yasbc reload", , "Hide")



; Middle-Click on Title bar to Close Window

~MButton::
{
    CoordMode "Mouse", "Screen"
    MouseGetPos(,, &id)
    if (id) {
        ; 0x84 is WM_NCHITTEST (checks where you clicked)
        ; 2 is the code for the Title Bar
        if (SendMessage(0x84,, (DllCall("GetMessagePos") & 0xFFFF) | (DllCall("GetMessagePos") >> 16 << 16),, "ahk_id " id) = 2) {
            PostMessage(0x0010, 0, 0,, "ahk_id " id) ; Send Close signal
        }
    }
}


; • MOVE TO WORKSPACES (0-7)

!+1::KCmd("move-to-workspace 0")
!+2::KCmd("move-to-workspace 1")
!+3::KCmd("move-to-workspace 2")
!+4::KCmd("move-to-workspace 3")
!+5::KCmd("move-to-workspace 4")
!+6::KCmd("move-to-workspace 5")
!+7::KCmd("move-to-workspace 6")
!+8::KCmd("move-to-workspace 7")


; • FLUID LINE SELECTORS & EDITING (GLOBAL)

; Select from cursor to end of line
+Right::Send("+{End}")

; Select from cursor to start of line
+Left::Send("+{Home}")

; Copy the ENTIRE line
!c::Send("{Home}+{End}^c")

; Duplicate the current line (Copy, New Line, Paste)
!d::Send("{Home}+{End}^c{End}{Enter}^v")

; The "Line Obliterator" (Wipes the line and resets)
+BackSpace::Send("{Home}+{End}{BackSpace}")


; • AUTO-CLICKER (F9 Toggle)

#MaxThreadsPerHotkey 2
f9::
{
    static Clicking := false
    static ClickSpeed := 10 ; Default 10ms (Super Fast)
    
    Clicking := !Clicking ; Toggle the state
    
    if (Clicking) {
        ; Start the timer
        SetTimer(DoTheClick, ClickSpeed)
    } else {
        ; Stop the timer
        SetTimer(DoTheClick, 0)
    }
}
DoTheClick()
{
if GetKeyState("Shift", "P") 
        Click "Right"
    else if GetKeyState("Ctrl", "P") 
        Click "Middle"
    else
        Click
}

; • OverLord Bio
!F4::
{
    ; Spawns your personal bio landing page directly inside Default Browser
    Run("https://linktr.ee/Hyprlands")
}


; Alt + V: Paste as Plain Text (Clean Code)

$^v::
{
    if DllCall("IsClipboardFormatAvailable", "UInt", 1) ; CF_TEXT guard clause
    {
        A_Clipboard := A_Clipboard ; Strips formatting safely
    }
    Send "^v"
}


; • My own gui ( Win+\ Toggle)

#\::
{
    static MyGui := 0
    if (MyGui) {
        MyGui.Destroy()
        MyGui := 0
        return
    }

    ; --- Configuration ---
    BgColor := "11111b"    ; Hyprland style background
    TextColor := "c0caf5"  ; Soft white/blue text
    AccentColor := "00d1ff" ; Your signature Cyan

    MyGui := Gui("-Caption +AlwaysOnTop +Border", "Hyprlands HUD")
    MyGui.BackColor := BgColor
    MyGui.SetFont("s11 w600", "JetBrains Mono") ; Larger, bold font

    ; --- Content ---
    MyGui.SetFont("s11 w700", "JetBrains Mono") 
    MyGui.Add("Text", "Center w450 c" . AccentColor, "     • HYPRLANDS OS: CORE SYSTEM BINDINGS • ")
    
    MyGui.SetFont("c" . TextColor . " s11")
    s := "`n• SYSTEM`n"
    s .= "Alt + O : Reload AHK Configuration`n"
    s .= "Alt + Shift + O : Reload Komorebi Tiling Manager`n"
    s .= "Alt + Shift + Z : Open Zen Browser`n"
    s .= "Alt + Shift + C: Open Cursor`n"
    s .= "Win + Enter : Launch Windows Terminal (wt)`n`n"

    s .= "• WINDOW MANAGEMENT`n"
    s .= "Alt + Shift + Q : Kill Active Process (Close)`n"
    s .= "Alt + Shift + M : Minimize Window`n"
    s .= "Alt + F : Toggle Floating Mode`n"
    s .= "Alt + Shift + F : Toggle Monocle (Fullscreen)`n`n"

    s .= "• NAVIGATION / WORKSPACES`n"
    s .= "Alt + [Arrow Keys] : Focus Window`n"
    s .= "Alt + [1-8] : Switch to Workspace (0-7)`n"
    s .= "Alt + Shift + [1-8] : Move Window to Workspace`n`n"
    
    s .= "• FLUID LINE EDITING`n"
    s .= "Shift + L/R: Select to Start/End`n"
    s .= "Alt + C : Copy Line`n"
    s .= "Alt + D : Duplicate Line`n"
    s .= "Alt + BackSpace : Obliterate Line`n"
    s .= "Alt + F4 : Bio of Overlord"

    MyGui.Add("Text", "w450", s)
    
    MyGui.SetFont("c" . AccentColor . " s9")
    MyGui.Add("Text", "Center w450", "[ Press 🪟 + \ again to close ]")

    MyGui.Show("Center")
}
