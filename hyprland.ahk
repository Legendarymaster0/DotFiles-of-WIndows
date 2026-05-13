#Requires AutoHotkey v2.0
#SingleInstance Force
SetWorkingDir A_InitialWorkingDir
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

+RButton::
{
    MouseGetPos(&mX, &mY, &WindowID)
    if !WindowID
        return
    WinGetPos(&wX, &wY, &wW, &wH, "ahk_id " WindowID)
    WinActivate("ahk_id " WindowID)
    
    relX := mX - wX
    relY := mY - wY
    
    if (relX + relY < (wW + wH) / 2) {
        PostMessage(0x0112, 0xF004, 0, , "ahk_id " WindowID)  ;Top-Left
    } else {
        PostMessage(0x0112, 0xF008, 0, , "ahk_id " WindowID)  ;Bottom-Right
    }
    KeyWait "RButton"      ; Wait for you to let go of Right Click
    Click "Left Up"        ; Simulate a Left-Up to "drop" the window and snap it
}


; • SYSTEM & RELOAD

!o::Reload()                                            
!+o::Run("komorebic.exe reload-configuration", , "Hide")    


; • APPS

#Enter::Run("wt")  ;Win + Enter: Windows Terminal (Classic Linux Feel)
!+z::Run("C:\Program Files\Zen\zen.exe")
!+c::RUN("C:\Program Files\cursor\cursor.exe")


; • WINDOW MANAGEMENT

!+q::Run("komorebic.exe close", , "Hide")
!+m::Run("komorebic.exe minimize", , "Hide")
!f::
{
    Run("komorebic.exe toggle-float", , "Hide")
    WinGetPos(,, &wW, &wH, "A")
    WinMove((A_ScreenWidth/2)-(wW/2), (A_ScreenHeight/2)-(wH/2),,, "A")
}
!+f::Run("komorebic.exe toggle-monocle", , "Hide")
!q::Run("komorebic.exe retile", , "Hide")
!p::Run("komorebic.exe toggle-pause", , "Hide")


; • FOCUS WINDOWS

!Left::Run("komorebic.exe focus left", , "Hide")
!Down::Run("komorebic.exe focus down", , "Hide")
!Up::Run("komorebic.exe focus up", , "Hide")
!Right::Run("komorebic.exe focus right", , "Hide")
!+[::Run("komorebic.exe cycle-focus previous", , "Hide")
!+]::Run("komorebic.exe cycle-focus next", , "Hide")


; • MOVE WINDOWS

!+Left::Run("komorebic.exe move left", , "Hide")
!+Down::Run("komorebic.exe move down", , "Hide")
!+Up::Run("komorebic.exe move up", , "Hide")
!+Right::Run("komorebic.exe move right", , "Hide")
!+Enter::Run("komorebic.exe promote", , "Hide")


; • RESIZE WINDOWS (AXIS)

!=::Run("komorebic.exe resize-axis horizontal increase", , "Hide")
!-::Run("komorebic.exe resize-axis horizontal decrease", , "Hide")
!+=::Run("komorebic.exe resize-axis vertical increase", , "Hide")
!+-::Run("komorebic.exe resize-axis vertical decrease", , "Hide")


; • LAYOUTS

!x::Run("komorebic.exe flip-layout horizontal", , "Hide")
!y::Run("komorebic.exe flip-layout vertical", , "Hide")
!+x::Run("komorebic.exe cycle-layout next", , "Hide")
!+y::Run("komorebic.exe cycle-layout previous", , "Hide")


; • FOCUS WORKSPACES (0-7)

!1::Run("komorebic.exe focus-workspace 0", , "Hide")
!2::Run("komorebic.exe focus-workspace 1", , "Hide")
!3::Run("komorebic.exe focus-workspace 2", , "Hide")
!4::Run("komorebic.exe focus-workspace 3", , "Hide")
!5::Run("komorebic.exe focus-workspace 4", , "Hide")
!6::Run("komorebic.exe focus-workspace 5", , "Hide")
!7::Run("komorebic.exe focus-workspace 6", , "Hide")
!8::Run("komorebic.exe focus-workspace 7", , "Hide")


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

!+1::Run("komorebic.exe move-to-workspace 0", , "Hide")
!+2::Run("komorebic.exe move-to-workspace 1", , "Hide")
!+3::Run("komorebic.exe move-to-workspace 2", , "Hide")
!+4::Run("komorebic.exe move-to-workspace 3", , "Hide")
!+5::Run("komorebic.exe move-to-workspace 4", , "Hide")
!+6::Run("komorebic.exe move-to-workspace 5", , "Hide")
!+7::Run("komorebic.exe move-to-workspace 6", , "Hide")
!+8::Run("komorebic.exe move-to-workspace 7", , "Hide")


; • FLUID LINE SELECTORS & EDITING

; Select from cursor to end of line
+Right::Send("+{End}")

; Select from cursor to start of line
+Left::Send("+{Home}")

; Select the ENTIRE line (No matter where cursor is)
!l::Send("{Home}+{End}")

; Copy the ENTIRE line
!c::Send("{Home}+{End}^c")

; Duplicate the current line (Copy, New Line, Paste)
!d::Send("{Home}+{End}^c{End}{Enter}^v")

; The "Line Obliterator" (Wipes the line and resets)
!BackSpace::Send("{Home}+{End}{BackSpace}")


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
    Click
}

; • My own gui ( Alt+\ Toggle)
+\::
{
    static MyGui := 0
    if (MyGui) {
        MyGui.Destroy()
        MyGui := 0
        return
    }

    ; --- Configuration ---
    BgColor := "11111b"    ; Dark Tokyo Night style background
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

    s .= "• NAVIGATION & WORKSPACES`n"
    s .= "Alt + [Arrow Keys] : Focus Window`n"
    s .= "Alt + [1-8] : Switch to Workspace (0-7)`n"
    s .= "Alt + Shift + [1-8] : Move Window to Workspace`n`n"
    
    s .= "• FLUID LINE EDITING`n"
    s .= "Shift + L/R: Select to Start/End`n"
    s .= "Alt + L : Select Line`n"
    s .= "Alt + C : Copy Line`n"
    s .= "Alt + D : Duplicate Line`n"
    s .= "Alt + BackSpace : Obliterate Line"

    MyGui.Add("Text", "w450", s)
    
    MyGui.SetFont("c" . AccentColor . " s9")
    MyGui.Add("Text", "Center w450", "`n[ Press Shift + \ again to close ]")

    MyGui.Show("Center")
}
