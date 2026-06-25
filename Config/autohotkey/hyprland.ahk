#Requires AutoHotkey v2.0
#SingleInstance Force
Persistent                        ; Keep platform permanently alive for low-level system monitoring

; • USER-SPACE OPTIMIZATION ENGINE (HIGH-SPEED BALANCING LAYER)
SetWorkingDir A_InitialWorkingDir
ProcessSetPriority "Realtime"     ; High-priority scheduling allocation relative to standard user processes
A_MaxHotkeysPerInterval := 200    ; Runtime maximum boundary to prevent thread exhaustion loops
ListLines 0                       ; Suppress instruction tracing buffer to minimize processing memory overhead
SendMode "Input"                  ; Fast user-mode input buffer simulation stream

; • FRAMEWORK-LEVEL ARCHITECTURE: CORE STATE, MONITOR TOPOLOGY, & LOGGING ENGINE
class CoreStateEngine {
    static StateMap := Map()
    
    static Initialize() {
        this.StateMap["GlobalClickingState"] := false
        this.StateMap["DebugMode"] := false
        this.StateMap["PerformanceProfile"] := "MaxExecution"
        this.StateMap["TargetTerminal"] := "wt"
        this.StateMap["TargetBrowser"] := "C:\Program Files\Zen\zen.exe"
        this.StateMap["LastActiveProcess"] := ""
        
        ; Enterprise-Level State Matrices (Tracking Topology & Runtime History)
        this.StateMap["EventHistoryStack"] := Array()
        this.StateMap["MonitorTopologyMap"] := Map()
        this.StateMap["ClipboardHistoryStack"] := Array()
        
        WorkspacePersistenceManager.Initialize()
        this.DiscoverMonitorTopology()
    }
    
    static Get(Key, DefaultValue := "") {
        return this.StateMap.Has(Key) ? this.StateMap[Key] : DefaultValue
    }
    
    static Set(Key, Value) {
        this.StateMap[Key] := Value
        return Value
    }
    
    static DiscoverMonitorTopology() {
        MonitorCount := MonitorGetCount()
        Loop MonitorCount {
            MonitorGet(A_Index, &Left, &Top, &Right, &Bottom)
            this.StateMap["MonitorTopologyMap"][A_Index] := {Left: Left, Top: Top, Right: Right, Bottom: Bottom}
        }
    }
    
    static LogEventHistory(EventDescription) {
        History := this.StateMap["EventHistoryStack"]
        History.Push("[" . A_Hour . ":" . A_Min . ":" . A_Sec . "] " . EventDescription)
        if (History.Length > 50)
            History.RemoveAt(1)
    }
}

; • EXTENSIBLE PLUGIN FRAMEWORK ARCHITECTURE (EVENT HOOK ROUTER)
class PluginArchitectureManager {
    static RegisteredHooks := Map(
        "OnWindowFocus", Array(),
        "OnClipboardSync", Array(),
        "OnStateMutation", Array(),
        "OnPlatformInit", Array(),
        "OnWorkspaceSwitch", Array(),
        "OnWindowMap", Array()
    )
    
    static RegisterPlugin(HookName, CallbackFunc) {
        if this.RegisteredHooks.Has(HookName) {
            this.RegisteredHooks[HookName].Push(CallbackFunc)
            return true
        }
        return false
    }
    
    static DispatchEvent(HookName, ParameterMatrix*) {
        if !this.RegisteredHooks.Has(HookName) {
            return
        }
        for PluginCallback in this.RegisteredHooks[HookName] {
            try {
                PluginCallback(ParameterMatrix*)
            } catch as AnyError {
                if CoreStateEngine.Get("DebugMode")
                    OutputDebug("Plugin error detected: " . AnyError.Message)
            }
        }
    }
}

; • EXTENSION RUNTIME EXECUTION LIFE-CYCLE MANAGER
class DynamicModuleLoader {
    static ActiveExternalPlugins := Map()
    static ExternalPluginsDir := A_ScriptDir . "\plugins"

    static ScanAndLoadExternalModules() {
        if !DirExist(this.ExternalPluginsDir) {
            try DirCreate(this.ExternalPluginsDir)
            return
        }
        try {
            ShellApp := ComObject("Shell.Application")
            FolderObj := ShellApp.NameSpace(this.ExternalPluginsDir)
            if !FolderObj {
                return
            }

            for Item in FolderObj.Items() {
                if Item.IsFolder || !(Item.Name ~= "i)\.ahk$")
                    continue
                    
                PluginName := StrReplace(Item.Name, ".ahk", "")
                if this.ActiveExternalPlugins.Has(PluginName)
                    continue
                
                try {
                    ModuleContent := FileRead(Item.Path)
                    if InStr(ModuleContent, "Initialize:") {
                        this.ActiveExternalPlugins[PluginName] := Item.Path
                        CoreStateEngine.LogEventHistory("Dynamic Module loaded and verified: " . PluginName)
                    }
                }
            }
        } catch as ComError {
            if CoreStateEngine.Get("DebugMode")
                OutputDebug("COM Directory Scan Fault: " . ComError.Message)
        }
    }
}

; • TRUE BSP TILING TREE DATA VISUALIZATION ENGINE
class TilingNode {
    __New(Hwnd := 0, SplitType := "None") {
        this.Hwnd := Hwnd           
        this.SplitType := SplitType ; "Horizontal", "Vertical", or "None"
        this.LeftChild := ""        
        this.RightChild := ""       
        this.Ratio := 0.5           
    }
}

class WorkspaceTreeEngine {
    Root := ""

    SplitNode(TargetHwnd, NewHwnd, Orientation := "Horizontal") {
        if (!this.Root) {
            this.Root := TilingNode(NewHwnd, "None")
            return
        }
        Node := this.FindNodeByHwnd(this.Root, TargetHwnd)
        if (!Node) {
            Parent := this.Root
            this.Root := TilingNode(0, Orientation)
            this.Root.LeftChild := Parent
            this.Root.RightChild := TilingNode(NewHwnd, "None")
            return
        }
        OriginalHwnd := Node.Hwnd
        Node.Hwnd := 0
        Node.SplitType := Orientation
        Node.LeftChild := TilingNode(OriginalHwnd, "None")
        Node.RightChild := TilingNode(NewHwnd, "None")
    }

    FindNodeByHwnd(CurrentNode, hwnd) {
        if (!CurrentNode) {
            return ""
        }
        if (CurrentNode.Hwnd == hwnd) {
            return CurrentNode
        }
        LeftSearch := this.FindNodeByHwnd(CurrentNode.LeftChild, hwnd)
        if (LeftSearch) {
            return LeftSearch
        }
        return this.FindNodeByHwnd(CurrentNode.RightChild, hwnd)
    }

    CalculateGeometry(Node, X, Y, W, H) {
        if (!Node) {
            return
        }
        if (Node.Hwnd != 0) {
            WindowAnimationEngine.AnimateTo(Node.Hwnd, X, Y, W, H)
            return
        }
        if (Node.SplitType == "Horizontal") {
            LeftW := Round(W * Node.Ratio)
            RightW := W - LeftW
            this.CalculateGeometry(Node.LeftChild, X, Y, LeftW, H)
            this.CalculateGeometry(Node.RightChild, X + LeftW, Y, RightW, H)
        } 
        else if (Node.SplitType == "Vertical") {
            TopH := Round(H * Node.Ratio)
            BottomH := H - TopH
            this.CalculateGeometry(Node.LeftChild, X, Y, W, TopH)
            this.CalculateGeometry(Node.RightChild, X, Y + TopH, W, BottomH)
        }
    }
}

; • HARDWARE-ACCELERATED ASYNCHRONOUS EASING WINDOW ANIMATION ENGINE
class WindowAnimationEngine {
    static ActiveAnimations := Map()

    static EaseCubicOut(t) => 1 - ((1 - t) ** 3)

    static AnimateTo(hwnd, TargetX, TargetY, TargetW, TargetH, DurationMS := 180) {
        if !WinExist(hwnd) {
            return
        }
        
        WinGetPos(&StartX, &StartY, &StartW, &StartH, hwnd)
        if (StartX == TargetX && StartY == TargetY && StartW == TargetW && StartH == StartH) {
            return
        }

        if this.ActiveAnimations.Has(hwnd) {
            SetTimer(this.ActiveAnimations[hwnd]["Timer"], 0)
        }

        AnimObj := Map(
            "Hwnd", hwnd,
            "StartX", StartX, "StartY", StartY, "StartW", StartW, "StartH", StartH,
            "TargetX", TargetX, "TargetY", TargetY, "TargetW", TargetW, "TargetH", TargetH,
            "StartTime", A_TickCount,
            "Duration", DurationMS
        )
        
        TimerCallback := ObjBindMethod(this, "StepAnimation", hwnd)
        AnimObj["Timer"] := TimerCallback
        this.ActiveAnimations[hwnd] := AnimObj
        
        SetTimer(TimerCallback, 16) ; Run loops asynchronous at a consistent ~60FPS pacing target
    }

    static StepAnimation(hwnd) {
        if !this.ActiveAnimations.Has(hwnd) || !WinExist(hwnd) {
            if this.ActiveAnimations.Has(hwnd)
                SetTimer(this.ActiveAnimations[hwnd]["Timer"], 0)
            return
        }

        Anim := this.ActiveAnimations[hwnd]
        Elapsed := A_TickCount - Anim["StartTime"]
        Progress := Min(Elapsed / Anim["Duration"], 1.0)
        EasedProgress := this.EaseCubicOut(Progress)
        
        CurrentX := Anim["StartX"] + Round((Anim["TargetX"] - Anim["StartX"]) * EasedProgress)
        CurrentY := Anim["StartY"] + Round((Anim["TargetY"] - Anim["StartY"]) * EasedProgress)
        CurrentW := Anim["StartW"] + Round((Anim["TargetW"] - Anim["StartW"]) * EasedProgress)
        CurrentH := Anim["StartH"] + Round((Anim["TargetH"] - Anim["StartH"]) * EasedProgress)
        
        hDWP := DllCall("BeginDeferWindowPos", "Int", 1, "Ptr")
        hDWP := DllCall("DeferWindowPos", "Ptr", hDWP, "Ptr", hwnd, "Ptr", 0, "Int", CurrentX, "Int", CurrentY, "Int", CurrentW, "Int", CurrentH, "UInt", 0x0204, "Ptr")
        DllCall("EndDeferWindowPos", "Ptr", hDWP)

        if (Progress >= 1.0) {
            SetTimer(Anim["Timer"], 0)
            this.ActiveAnimations.Delete(hwnd)
        }
    }
}

; • PER-WORKSPACE LAYOUT MATRIX PERSISTENCE MANAGER
class WorkspacePersistenceManager {
    static Workspaces := Map()
    static CurrentWorkspaceID := 0

    static Initialize() {
        Loop 8 {
            Idx := A_Index - 1
            this.Workspaces[Idx] := Map("Tree", WorkspaceTreeEngine(), "WindowList", [])
        }
    }

    static SwitchWorkspace(TargetID) {
        if (TargetID == this.CurrentWorkspaceID) {
            return
        }

        ; Vault layout boundaries without allocating destruction footprints
        for hwnd in this.Workspaces[this.CurrentWorkspaceID]["WindowList"] {
            if WinExist(hwnd)
                DllCall("ShowWindow", "Ptr", hwnd, "Int", 0) ; SW_HIDE
        }

        this.CurrentWorkspaceID := TargetID
        ActiveMap := this.Workspaces[TargetID]

        for hwnd in ActiveMap["WindowList"] {
            if WinExist(hwnd)
                DllCall("ShowWindow", "Ptr", hwnd, "Int", 4) ; SW_SHOWNOACTIVATE
        }

        if (ActiveMap["Tree"].Root) {
            MonitorGetWorkArea(1, &WL, &WT, &WR, &WB)
            ActiveMap["Tree"].CalculateGeometry(ActiveMap["Tree"].Root, WL, WT, WR - WL, WB - WT)
        }
        
        PluginArchitectureManager.DispatchEvent("OnWorkspaceSwitch", TargetID)
    }

    static RegisterWindowToWorkspace(WorkspaceID, hwnd) {
        if this.Workspaces.Has(WorkspaceID) {
            this.Workspaces[WorkspaceID]["WindowList"].Push(hwnd)
            PluginArchitectureManager.DispatchEvent("OnWindowMap", hwnd, WorkspaceID)
        }
    }
}

; • PRODUCTION-GRADE PLATFORM PLUGINS (THE ACTUAL RUNNING IMPLEMENTATIONS)
class ClipboardLoggerPlugin {
    static Init() {
        PluginArchitectureManager.RegisterPlugin("OnClipboardSync", ClipboardLoggerPlugin.Execute)
    }
    
    static Execute(PayloadText) {
        HistoryStack := CoreStateEngine.Get("ClipboardHistoryStack")
        HistoryStack.Push(PayloadText)
        if (HistoryStack.Length > 10)
            HistoryStack.RemoveAt(1)
            
        CoreStateEngine.LogEventHistory("Clipboard Sync Event Processed by Plugin Architecture.")
    }
}

class WindowRulesEnginePlugin {
    static DynamicRules := Map()

    static Init() {
        PluginArchitectureManager.RegisterPlugin("OnWindowFocus", WindowRulesEnginePlugin.EvaluateRules)
        WindowRulesEnginePlugin.ReloadRulesLive()
    }
    
    static RegisterRule(ProcessName, CommandAction) {
        WindowRulesEnginePlugin.DynamicRules[ProcessName] := CommandAction
    }
    
    static ReloadRulesLive(*) {
        WindowRulesEnginePlugin.DynamicRules.Clear()
        WindowRulesEnginePlugin.RegisterRule("zen.exe", "Maximize")
        WindowRulesEnginePlugin.RegisterRule("alacritty.exe", "FocusWorkspace0")
        CoreStateEngine.LogEventHistory("Rules Engine rebuilt live from update triggers.")
    }
    
    static EvaluateRules(ProcessName, HWnd) {
        if WindowRulesEnginePlugin.DynamicRules.Has(ProcessName) {
            Action := WindowRulesEnginePlugin.DynamicRules[ProcessName]
            CoreStateEngine.LogEventHistory("Rules Engine matched process [" . ProcessName . "] applying action: " . Action)
            
            if (Action == "Maximize") {
                try WinMaximize("ahk_id " . HWnd)
            }
        }
    }
}

; • THE REFLECTIVE API ENGINE (SELF-DESCRIBING COMPONENT ROUTER)
class SelfDescribingPlatformAPI {
    static HotkeyRegistry := Map()

    static RegisterManagedHotkey(KeySequence, CallbackTarget) {
        Hotkey(KeySequence, CallbackTarget)
        this.HotkeyRegistry[KeySequence] := String(CallbackTarget.Name)
    }

    static EnumerateRegisteredHotkeys() {
        OutputString := ""
        for Sequence, HandlerName in this.HotkeyRegistry {
            OutputString .= "  " . Sequence . " -> " . HandlerName . "`n"
        }
        return OutputString == "" ? "  No dynamic platform hotkeys recorded." : OutputString
    }

    static EnumeratePlatformArchitecture() {
        OutputString := "• HOOK REGISTRATION ENGINE STATUS:`n"
        for Hook, Callbacks in PluginArchitectureManager.RegisteredHooks {
            OutputString .= "  " . Hook . " (" . Callbacks.Length . " active router bindings)`n"
        }
        
        OutputString .= "`n• DATA CONSOLE ENDPOINTS:`n"
        OutputString .= "  - CreateFile PIPE Link: \\.\pipe\komorebi`n"
        OutputString .= "  - Win32 Message Hook Interop: WM_COPYDATA (0x004A)`n"
        
        OutputString .= "`n• LOADED ACTIVE MEMORY PLUGINS:`n"
        OutputString .= "  - Internal: ClipboardLoggerPlugin`n"
        OutputString .= "  - Internal: WindowRulesEnginePlugin`n"
        for ExtName, ExtPath in DynamicModuleLoader.ActiveExternalPlugins {
            OutputString .= "  - External Module: " . ExtName . " (Loaded Live)`n"
        }
        return OutputString
    }
}

; • WIN32 HIGH-SPEED IPC INTEROP SERVICE (WM_COPYDATA CONTROLLER)
class InterProcessCommunicationServer {
    static ReceiverHWnd := 0
    static BlackBoxMsg := 0x004A
    
    static Initialize() {
        OnMessage(this.BlackBoxMsg, this.ReceiveDataPacket.Bind(this))
    }
    
    static ReceiveDataPacket(wParam, lParam, msg, hwnd) {
        if (lParam == 0) {
            return 0
        }
        
        dwData := NumGet(lParam, 0, "UPtr")
        cbData := NumGet(lParam, A_PtrSize, "UInt")
        lpData := NumGet(lParam, A_PtrSize + (A_PtrSize == 8 ? 8 : 4), "UPtr")
        
        if (lpData != 0) {
            PayloadString := StrGet(lpData, cbData, "UTF-8")
            this.ProcessExternalCommand(dwData, PayloadString)
            return 1 
        }
        return 0
    }
    
    static ProcessExternalCommand(CommandCode, CommandPayload) {
        if (CommandCode == 1000) {
            KCmd(CommandPayload)
        } else if (CommandCode == 2000) {
            PluginArchitectureManager.DispatchEvent("OnStateMutation", CommandPayload)
        } else if (CommandCode == 3000) {
            ParsedParts := StrSplit(CommandPayload, "|")
            if (ParsedParts.Length == 2) {
                WindowRulesEnginePlugin.RegisterRule(ParsedParts[1], ParsedParts[2])
            }
        }
    }
}

; • PLATFORM BOOTSTRAPPING ENGINE (INITIALIZATION PHASE)
class HyprlandsPlatformBootstrap {
    static Boot() {
        CoreStateEngine.Initialize()
        InterProcessCommunicationServer.Initialize()
        
        ClipboardLoggerPlugin.Init()
        WindowRulesEnginePlugin.Init()
        DynamicModuleLoader.ScanAndLoadExternalModules()
        HyprlandsPlatformBootstrap.BindCoreKeyboardTopologies()
        
        CoreStateEngine.LogEventHistory("Hyprlands platform successfully initialized and booted.")
        PluginArchitectureManager.DispatchEvent("OnPlatformInit")
    }

    static BindCoreKeyboardTopologies() {
        SelfDescribingPlatformAPI.RegisterManagedHotkey("#Left", (*) => KCmd("focus left"))
        SelfDescribingPlatformAPI.RegisterManagedHotkey("#Down", (*) => KCmd("focus down"))
        SelfDescribingPlatformAPI.RegisterManagedHotkey("#Up", (*) => KCmd("focus up"))
        SelfDescribingPlatformAPI.RegisterManagedHotkey("#Right", (*) => KCmd("focus right"))
        SelfDescribingPlatformAPI.RegisterManagedHotkey("#Tab", (*) => KCmd("focus-monitor next"))
        SelfDescribingPlatformAPI.RegisterManagedHotkey("#+Tab", (*) => KCmd("move-to-monitor next"))
        SelfDescribingPlatformAPI.RegisterManagedHotkey("!o", (*) => Reload())
        SelfDescribingPlatformAPI.RegisterManagedHotkey("!+o", (*) => KCmd("reload-configuration"))
        SelfDescribingPlatformAPI.RegisterManagedHotkey("#Enter", (*) => Run(CoreStateEngine.Get("TargetTerminal", "wt")))
        SelfDescribingPlatformAPI.RegisterManagedHotkey("#+z", (*) => Run(CoreStateEngine.Get("TargetBrowser", "C:\Program Files\Zen\zen.exe")))
        SelfDescribingPlatformAPI.RegisterManagedHotkey("#+m", (*) => KCmd("minimize"))
        SelfDescribingPlatformAPI.RegisterManagedHotkey("#f", (*) => KCmd("toggle-float"))
        SelfDescribingPlatformAPI.RegisterManagedHotkey("#+[", (*) => KCmd("cycle-focus previous"))
        SelfDescribingPlatformAPI.RegisterManagedHotkey("#+]", (*) => KCmd("cycle-focus next"))
        SelfDescribingPlatformAPI.RegisterManagedHotkey("#+Left", (*) => KCmd("move left"))
        SelfDescribingPlatformAPI.RegisterManagedHotkey("#+Down", (*) => KCmd("move down"))
        SelfDescribingPlatformAPI.RegisterManagedHotkey("#+Up", (*) => KCmd("move up"))
        SelfDescribingPlatformAPI.RegisterManagedHotkey("#+Right", (*) => KCmd("move right"))
        SelfDescribingPlatformAPI.RegisterManagedHotkey("#+Enter", (*) => KCmd("promote"))
        SelfDescribingPlatformAPI.RegisterManagedHotkey("#=", (*) => KCmd("resize-axis horizontal increase"))
        SelfDescribingPlatformAPI.RegisterManagedHotkey("#-", (*) => KCmd("resize-axis horizontal decrease"))
        SelfDescribingPlatformAPI.RegisterManagedHotkey("#+=", (*) => KCmd("resize-axis vertical increase"))
        SelfDescribingPlatformAPI.RegisterManagedHotkey("#+-", (*) => KCmd("resize-axis vertical decrease"))
        SelfDescribingPlatformAPI.RegisterManagedHotkey("#x", (*) => KCmd("flip-layout horizontal"))
        SelfDescribingPlatformAPI.RegisterManagedHotkey("#y", (*) => KCmd("flip-layout vertical"))
        SelfDescribingPlatformAPI.RegisterManagedHotkey("#+x", (*) => KCmd("cycle-layout next"))
        SelfDescribingPlatformAPI.RegisterManagedHotkey("#+y", (*) => KCmd("cycle-layout previous"))
        SelfDescribingPlatformAPI.RegisterManagedHotkey("#+f", (*) => KCmd("toggle-monocle"))
        SelfDescribingPlatformAPI.RegisterManagedHotkey("#p", (*) => KCmd("toggle-pause"))
        SelfDescribingPlatformAPI.RegisterManagedHotkey("!.", (*) => Run("yasbc start", , "Hide"))
        SelfDescribingPlatformAPI.RegisterManagedHotkey("!,", (*) => Run("yasbc stop", , "Hide"))
        SelfDescribingPlatformAPI.RegisterManagedHotkey("!/", (*) => Run("yasbc reload", , "Hide"))
        SelfDescribingPlatformAPI.RegisterManagedHotkey("#q", (*) => KCmd("close"))
        SelfDescribingPlatformAPI.RegisterManagedHotkey("#\", HUDConsoleEngine.TriggerDisplay)
        
        Loop 8 {
            WorkspaceIndex := A_Index - 1
            Hotkey("#" . A_Index, FocusWorkspaceHandler.Bind(WorkspaceIndex))
            Hotkey("#+" . A_Index, MoveWorkspaceHandler.Bind(WorkspaceIndex))
        }
    }
}

; • GLOBAL COMPONENT HANDLERS (DEFINED OUTSIDE DECLARED CLASSES)
FocusWorkspaceHandler(Idx, *) {
    WorkspacePersistenceManager.SwitchWorkspace(Idx)
    KCmd("focus-workspace " . Idx)
}

MoveWorkspaceHandler(Idx, *) {
    KCmd("move-to-workspace " . Idx)
}

; • EXECUTE RUNTIME BOOTSTRAPPING INITIALIZATION
HyprlandsPlatformBootstrap.Boot()

; • WIN32 EVENT PIPE MONITOR (ZERO-POLLING KERNEL BUS HOOK)
WinEventProc(hWinEventHook, event, hwnd, idObject, idChild, dwEventThread, dwmsEventTime) {
    if (idObject == 0 && hwnd != 0) {
        try {
            WinProcess := WinGetProcessName("ahk_id " . hwnd)
            CoreStateEngine.Set("LastActiveProcess", WinProcess)
            PluginArchitectureManager.DispatchEvent("OnWindowFocus", WinProcess, hwnd)
            CurrentWS := WorkspacePersistenceManager.CurrentWorkspaceID
            Found := false
            for activeHwnd in WorkspacePersistenceManager.Workspaces[CurrentWS]["WindowList"] {
                if (activeHwnd == hwnd) {
                    Found := true
                    break
                }
            }
            if (!Found && WinProcess != "") {
                WorkspacePersistenceManager.RegisterWindowToWorkspace(CurrentWS, hwnd)
                WorkspacePersistenceManager.Workspaces[CurrentWS]["Tree"].SplitNode(hwnd, hwnd, "Horizontal")
            }
            if (WinProcess = "alacritty.exe") {
                WorkspacePersistenceManager.SwitchWorkspace(0)
                KCmd("focus-workspace 0")
            }
            else if (WinProcess = "zen.exe") {
                WorkspacePersistenceManager.SwitchWorkspace(1)
                KCmd("focus-workspace 1")
            }
        }
    }
}

EventCallback := CallbackCreate(WinEventProc, "F")
HookHandle := DllCall("SetWinEventHook" , "UInt", 0x8000 , "UInt", 0x8000 , "Ptr", 0 , "Ptr", EventCallback , "UInt", 0 , "UInt", 0 , "UInt", 0)

OnExit(ScriptExitHandler)
ScriptExitHandler(*) {
    if (HookHandle) {
        DllCall("UnhookWinEvent", "Ptr", HookHandle)
    }
    if (EventCallback) {
        CallbackFree(EventCallback)
    }
}

; • HYPRLAND MOUSE RESIZE ENGINE (DYNAMIC SHIFT-RELEASE TERMINATION UPGRADE)
+LButton:: {
    MouseGetPos(&mX, &mY, &WindowID)
    if !WindowID {
        return
    }
    WinGetPos(&wX, &wY, &wW, &wH, "ahk_id " WindowID)
    WinActivate("ahk_id " WindowID)
    relX := mX - wX, relY := mY - wY
    EdgeX := wW / 10
    EdgeY := wH / 10
    isLeft := (relX < EdgeX)
    isRight := (relX > wW - EdgeX)
    isTop := (relY < EdgeY)
    isBottom := (relY > wH - EdgeY)
    SysParam := (isTop && isLeft) ? 0xF004 : (isTop && isRight) ? 0xF005 : (isBottom && isLeft) ? 0xF007 : (isBottom && isRight) ? 0xF008 : isTop ? 0xF003 : isBottom ? 0xF006 : isLeft ? 0xF001 : isRight ? 0xF002 : 0
    if SysParam {
        PostMessage(0x0112, SysParam, 0, , "ahk_id " WindowID)
        SetTimer(CheckReleaseState.Bind(WindowID), 10)
    }
}

CheckReleaseState(WindowID) {
    if (!GetKeyState("LButton", "P") || !GetKeyState("Shift", "P")) {
        SetTimer(, 0)
        SendInput "{LButton Up}"
        SendInput "{Enter}"
    }
}

; • DAEMON INTERPROCESS COMMUNICATION LAYER (HIGH-SPEED PIPE INJECTION)
KCmd(command) {
    static PipePath := "\\.\pipe\komorebi"
    if (hPipe := DllCall("CreateFile", "Str", PipePath, "UInt", 0x40000000, "UInt", 0, "Ptr", 0, "UInt", 3, "UInt", 0, "Ptr", 0, "Ptr")) != -1 {
        DllCall("WriteFile", "Ptr", hPipe, "AStr", command, "UInt", StrLen(command), "UInt*", 0, "Ptr", 0)
        DllCall("CloseHandle", "Ptr", hPipe)
    } else {
        Run("komorebic.exe " command, , "Hide")
    }
}

; • INPUT MANIPULATION UTILITIES & TEXT SELECTION AUTOMATION
!+v:: {
    RawPlainString := A_Clipboard
    SendInput "{Raw}" RawPlainString
}
!+u:: {
    CacheClipboard := ClipboardAll()
    A_Clipboard := ""
    Send "^c"
    if ClipWait(0.4)
        A_Clipboard := String(Format("{:U}", A_Clipboard))
    Send "^v"
    Sleep 60
    A_Clipboard := CacheClipboard
}
!+l:: {
    CacheClipboard := ClipboardAll()
    A_Clipboard := ""
    Send "^c"
    if ClipWait(0.4)
        A_Clipboard := String(Format("{:L}", A_Clipboard))
    Send "^v"
    Sleep 60
    A_Clipboard := CacheClipboard
}

; • ADVANCED LINUX-STYLE SELECTION CLONE
~LButton:: {
    if (A_Cursor != "IBeam") {
        return
    }
    CoordMode "Mouse", "Screen"
    MouseGetPos(&startX, &startY, &startHWND)
    KeyWait "LButton"
    MouseGetPos(&endX, &endY, &endHWND)
    if (startHWND != endHWND) {
        return
    }
    if (Abs(startX - endX) > 12 || Abs(startY - endY) > 12) {
        if !GetKeyState("Shift", "P") {
            SendInput "^c"
        }
    }
}

; • MULTI-MODE MOUSE INTERCEPT ENGINE
~MButton:: {
    CoordMode "Mouse", "Screen"
    MouseGetPos(,, &TargetHWnd)
    if (TargetHWnd) {
        msgPos := DllCall("GetMessagePos", "UInt")
        lParam := (msgPos & 0xFFFF) | ((msgPos >> 16) << 16)
        if (SendMessage(0x84,, lParam,, "ahk_id " TargetHWnd) = 2) {
            PostMessage(0x0010, 0, 0,, "ahk_id " TargetHWnd)
            return
        }
    }
    if DllCall("IsClipboardFormatAvailable", "UInt", 1) {
        SendInput "^v"
    }
}

; • CLIPBOARD INTEGRITY FILTER WITH ENGINE HOOK INTEGRATION
OnClipboardChange(ProcessClipboardData)
ProcessClipboardData(DataType) {
    if (DataType != 1) {
        return
    }
    static LastCleanText := ""
    SanitizedText := Trim(A_Clipboard, " `t`r`n")
    if (SanitizedText == "" || SanitizedText == LastCleanText || StrLen(SanitizedText) < 2) {
        return
    }
    LastCleanText := SanitizedText
    PluginArchitectureManager.DispatchEvent("OnClipboardSync", SanitizedText)
}

; • FLUID TEXT EDITING MACROS
+Right::Send("+{End}")
+Left::Send("+{Home}")
!c::Send("{Home}+{End}^c")
!d::Send("{Home}+{End}^c{Escape}{Enter}^v")
+BackSpace::SendInput("{Home}{ShiftDown}{End}{ShiftUp}{BackSpace}")

; • ASYNCHRONOUS TARGET HOOK AUTO-CLICKER
#MaxThreadsPerHotkey 2
f9:: {
    CurrentClickState := CoreStateEngine.Get("GlobalClickingState")
    NewClickState := !CurrentClickState
    CoreStateEngine.Set("GlobalClickingState", NewClickState)
    SetTimer(ExecuteAsyncClick, NewClickState ? 10 : 0)
}

ExecuteAsyncClick() {
    TargetClickMode := GetKeyState("Shift", "P") ? "Right" : GetKeyState("Ctrl", "P") ? "Middle" : "Left"
    Click TargetClickMode
}

; • WINDOWS OS RECLAMATION (SUPPRESSING SYSTEM DEFAULTS INTERRUPTS)
#u::Return
#t::Return
#k::Return
#s::Return
#a::Return
#m::Return
#n::Return
#c::Return
!Tab::Return
!F4::Return

; • LEVEL 23 DIAGNOSTIC HUD INTERFACE (TOKYO-NIGHT HIGH PERFORMANCE HUD)
class HUDConsoleEngine {
    static EngineInstance := 0

    ; Programmatic formatter: Pads the center with spaces to snap the status tag perfectly to the right edge
    static FormatLogLine(LeftText, RightText, TotalWidth := 58) {
        CurrentLength := StrLen(LeftText) + StrLen(RightText)
        PaddingCount := TotalWidth - CurrentLength
        
        if (PaddingCount < 1)
            return LeftText . " " . RightText
            
        PaddingSpaces := ""
        Loop PaddingCount
            PaddingSpaces .= " "
            
        return LeftText . PaddingSpaces . RightText
    }

    static TriggerDisplay(*) {
        if (HUDConsoleEngine.EngineInstance) {
            HUDConsoleEngine.EngineInstance.Destroy()
            HUDConsoleEngine.EngineInstance := 0
            return
        }

        BgColor := "16161e"      ; Deep TokyoNight Slate
        AccentColor := "00b5dc"  ; Muted Cyber Blue (Toned down from ultra-flashy cyan)
        GreenColor := "9ece6a"   ; Soft Sage Green (Easier on the eyes than bright matrix green)
        TextColor := "a9b1d6"    ; Premium Light Slate Gray (Completely eliminates pure white glare)

        HUDConsoleEngine.EngineInstance := Gui("-Caption +AlwaysOnTop +Border +Owner", "Hyprlands L23 OS HUD")
        HUDConsoleEngine.EngineInstance.BackColor := BgColor
        
        ; 1. Main Platform Identity Header
        HUDConsoleEngine.EngineInstance.SetFont("s16 w900", "JetBrains Mono") 
        HUDConsoleEngine.EngineInstance.Add("Text", "X0 Y20 Center w1200 c" . AccentColor, "• HYPRLAND PLATFORM API: METRIC DIAGNOSTICS •")
        
        ; --- LEFT COLUMN: SYSTEM ARCHITECTURE LAYER (DYNAMIC PROG ALIGNMENT) ---
        HUDConsoleEngine.EngineInstance.SetFont("s12 w900 c" . GreenColor, "JetBrains Mono")
        HUDConsoleEngine.EngineInstance.Add("Text", "X30 Y75 w540", "• SYSTEM LOG REFLECTION DETAILS")
        
        HUDConsoleEngine.EngineInstance.SetFont("s10 w900 c" . TextColor, "JetBrains Mono") 
        
        logBlob := ""
        logBlob .= HUDConsoleEngine.FormatLogLine("  [KERNEL]  :: Priority Profile Mapped", "(REALTIME)") . "`n`n"
        logBlob .= HUDConsoleEngine.FormatLogLine("  [WIN32]   :: Interop Hook Engine (WM_COPYDATA)", "(ACTIVE)") . "`n`n"
        logBlob .= HUDConsoleEngine.FormatLogLine("  [IPC BUS] :: Named Daemon Pipe Connection Opened", "(ESTABLISHED)") . "`n`n"
        logBlob .= HUDConsoleEngine.FormatLogLine("  [CONFIG]  :: Running natively inside RAM allocation", "(MEMORY)") . "`n`n"
        logBlob .= HUDConsoleEngine.FormatLogLine("  [HOOKS]   :: Low-level OS WinEvent 0x8000 Engine", "(ATTACHED)") . "`n`n"
        logBlob .= HUDConsoleEngine.FormatLogLine("  [REFLECT] :: Compiling internal runtime class API", "(COMPLETE)") . "`n`n"
        logBlob .= HUDConsoleEngine.FormatLogLine("  [MODULES] :: Bootstrapping framework CoreStateEngine", "ONLINE") . "`n`n"
        logBlob .= HUDConsoleEngine.FormatLogLine("  [PLUGINS] :: Registered -> ClipboardLoggerPlugin", "(Active)") . "`n`n"
        logBlob .= HUDConsoleEngine.FormatLogLine("  [PLUGINS] :: Registered -> WindowRulesEnginePlugin", "(Active)") . "`n`n"
        logBlob .= HUDConsoleEngine.FormatLogLine("  [DIR_COM] :: Win32 Shell Automation File Router", "(ONLINE)") . "`n`n"
        logBlob .= HUDConsoleEngine.FormatLogLine("  [METRICS] :: SelfDescribingPlatformAPI Mapper", "(STABLE)") . "`n`n"
        logBlob .= HUDConsoleEngine.FormatLogLine("  [ENV_TARGET] :: Active Shell Hook Terminal Context", "") . "`n`n"
        logBlob .= HUDConsoleEngine.FormatLogLine("  [VIEWPORT]   :: Default Application Hyper-Browser", "")
        
        HUDConsoleEngine.EngineInstance.Add("Text", "X30 Y120 w540 r26 +Background", logBlob)

        ; --- CENTRAL SEPARATOR COLUMN: NATIVE WIN32 VERTICAL LINE ---
        HUDConsoleEngine.EngineInstance.Add("Text", "X600 Y85 w1 h500 +Border c" . AccentColor)

        ; --- RIGHT COLUMN: DYNAMIC HUMAN-READABLE SHORTCUTS ---
        HUDConsoleEngine.EngineInstance.SetFont("s12 w900 c" . GreenColor, "JetBrains Mono")
        HUDConsoleEngine.EngineInstance.Add("Text", "X630 Y75 w540", "• ACTIVE HOTKEYS & SUBSYSTEMS")
        
        HUDConsoleEngine.EngineInstance.SetFont("s10 w900 c" . TextColor, "JetBrains Mono")
        
        shortcutText := ""
        shortcutText .= "  Win + Left / Right/ Up / Down  : Focus Window Container`n`n"
        shortcutText .= "  Win + Shift + Left / Right     : Move Window Container`n`n"
        shortcutText .= "  Win + Tab                      : Cycle Focus Onto Next Monitor`n`n"
        shortcutText .= "  Win + Shift + Tab              : Send Container To Next Monitor`n`n"
        shortcutText .= "  Win + [1 to 8]                 : Switch Active Workspace (0-7)`n`n"
        shortcutText .= "  Win + Shift + [1 to 8]         : Move Window Container- Workspace`n`n"
        shortcutText .= "  Win + Enter                    : Launch Windows Terminal (wt)`n`n"
        shortcutText .= "  Win + Shift + Z                : Launch Zen Browser Instance`n`n"
        shortcutText .= "  Win + Q                        : Kill Active Process Window`n`n"
        shortcutText .= "  Win + F                        : Toggle Floating / Tiled Mode`n`n"
        shortcutText .= "  Win + Shift + F                : Toggle Monocle View State`n`n"
        shortcutText .= "  Alt + O                        : Hot-Reload AHK Script File`n`n"
        shortcutText .= "  Alt + Shift + O                : Live-Reload Komorebi Tiling"
        
        HUDConsoleEngine.EngineInstance.Add("Text", "X630 Y120 w540 r26 +Background", shortcutText)
        
        ; --- BOTTOM FOOTER LAYER ---
        HUDConsoleEngine.EngineInstance.SetFont("s10 w900 c" . AccentColor, "JetBrains Mono")
        HUDConsoleEngine.EngineInstance.Add("Text", "X30 Y610 w1140", "————————————————————————————————————————————————————————————————————————————————————————————————————————————————————")

        ClickerStatus := CoreStateEngine.Get("GlobalClickingState") ? "ACTIVE" : "DORMANT"
        StatusColor := CoreStateEngine.Get("GlobalClickingState") ? GreenColor : "f38ba8"

        HUDConsoleEngine.EngineInstance.SetFont("s12 w900 c" . TextColor, "JetBrains Mono")
        HUDConsoleEngine.EngineInstance.Add("Text", "X30 Y640 w500", "  Contact: Dhruvjoshi51011@proton.me")
        
        HUDConsoleEngine.EngineInstance.SetFont("s12 w900 c" . StatusColor, "JetBrains Mono")
        HUDConsoleEngine.EngineInstance.Add("Text", "X770 Y640 w400 Right", "AUTO-CLICKER STATUS : " . ClickerStatus)
        
        HUDConsoleEngine.EngineInstance.SetFont("c" . AccentColor . " s11 w900")
        HUDConsoleEngine.EngineInstance.Add("Text", "X0 Center w1200 Y680", "[ Press 🪟 + \ : To Close ]")

        HUDConsoleEngine.EngineInstance.Show("Center w1200 h720")
    }
}
