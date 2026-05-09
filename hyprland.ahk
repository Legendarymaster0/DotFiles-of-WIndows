#Requires AutoHotkey v2.0
#SingleInstance Force
SetWorkingDir A_InitialWorkingDir
;         _             _                _            _            _       _    _          _            _              _    _        _   
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
; -------------------------------------------------------------------------
; • HYPRLAND MOUSE RESIZE (Top-Left / Bottom-Right Logic)
; -------------------------------------------------------------------------
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
        PostMessage(0x0112, 0xF004, 0, , "ahk_id " WindowID) ; Top-Left
    } else {
        PostMessage(0x0112, 0xF008, 0, , "ahk_id " WindowID) ; Bottom-Right
    }
}

; -------------------------------------------------------------------------
; • SYSTEM & RELOAD
; -------------------------------------------------------------------------
!o::Reload()                                            ; Alt + O: Reload
!+o::Run("komorebic.exe reload-configuration", , "Hide") ; Alt + Shift + O
!i::Run("komorebic.exe toggle-shortcuts", , "Hide")      ; Alt + I

; -------------------------------------------------------------------------
; • APPS
; -------------------------------------------------------------------------
#Enter::Run("wt") ; Win + Enter: Windows Terminal (Classic Linux Feel)

; -------------------------------------------------------------------------
; • WINDOW MANAGEMENT
; -------------------------------------------------------------------------
!+q::Run("komorebic.exe close", , "Hide")
!+m::Run("komorebic.exe minimize", , "Hide")
!f::Run("komorebic.exe toggle-float", , "Hide")
!+f::Run("komorebic.exe toggle-monocle", , "Hide")
!q::Run("komorebic.exe retile", , "Hide")
!p::Run("komorebic.exe toggle-pause", , "Hide")

; -------------------------------------------------------------------------
; • FOCUS WINDOWS
; -------------------------------------------------------------------------
!Left::Run("komorebic.exe focus left", , "Hide")
!Down::Run("komorebic.exe focus down", , "Hide")
!Up::Run("komorebic.exe focus up", , "Hide")
!Right::Run("komorebic.exe focus right", , "Hide")
!+[::Run("komorebic.exe cycle-focus previous", , "Hide")
!+]::Run("komorebic.exe cycle-focus next", , "Hide")

; -------------------------------------------------------------------------
; • MOVE WINDOWS
; -------------------------------------------------------------------------
!+Left::Run("komorebic.exe move left", , "Hide")
!+Down::Run("komorebic.exe move down", , "Hide")
!+Up::Run("komorebic.exe move up", , "Hide")
!+Right::Run("komorebic.exe move right", , "Hide")
!+Enter::Run("komorebic.exe promote", , "Hide")

; -------------------------------------------------------------------------
; • RESIZE WINDOWS (AXIS)
; -------------------------------------------------------------------------
!=::Run("komorebic.exe resize-axis horizontal increase", , "Hide")
!-::Run("komorebic.exe resize-axis horizontal decrease", , "Hide")
!+=::Run("komorebic.exe resize-axis vertical increase", , "Hide")
!+-::Run("komorebic.exe resize-axis vertical decrease", , "Hide")

; -------------------------------------------------------------------------
; • LAYOUTS
; -------------------------------------------------------------------------
!x::Run("komorebic.exe flip-layout horizontal", , "Hide")
!y::Run("komorebic.exe flip-layout vertical", , "Hide")
!+x::Run("komorebic.exe cycle-layout next", , "Hide")
!+y::Run("komorebic.exe cycle-layout previous", , "Hide")

; -------------------------------------------------------------------------
; • FOCUS WORKSPACES (0-7)
; -------------------------------------------------------------------------
!1::Run("komorebic.exe focus-workspace 0", , "Hide")
!2::Run("komorebic.exe focus-workspace 1", , "Hide")
!3::Run("komorebic.exe focus-workspace 2", , "Hide")
!4::Run("komorebic.exe focus-workspace 3", , "Hide")
!5::Run("komorebic.exe focus-workspace 4", , "Hide")
!6::Run("komorebic.exe focus-workspace 5", , "Hide")
!7::Run("komorebic.exe focus-workspace 6", , "Hide")
!8::Run("komorebic.exe focus-workspace 7", , "Hide")

; -------------------------------------------------------------------------
; • MOVE TO WORKSPACES (0-7)
; -------------------------------------------------------------------------
!+1::Run("komorebic.exe move-to-workspace 0", , "Hide")
!+2::Run("komorebic.exe move-to-workspace 1", , "Hide")
!+3::Run("komorebic.exe move-to-workspace 2", , "Hide")
!+4::Run("komorebic.exe move-to-workspace 3", , "Hide")
!+5::Run("komorebic.exe move-to-workspace 4", , "Hide")
!+6::Run("komorebic.exe move-to-workspace 5", , "Hide")
!+7::Run("komorebic.exe move-to-workspace 6", , "Hide")
!+8::Run("komorebic.exe move-to-workspace 7", , "Hide")
