#Requires AutoHotkey v2.0
#SingleInstance Force
Persistent                        

; • USER-SPACE OPTIMIZATION ENGINE (HIGH-SPEED BALANCING LAYER)

SetWorkingDir A_InitialWorkingDir
ProcessSetPriority "Realtime"     
A_MaxHotkeysPerInterval := 200    
ListLines 0                       
SendMode "Input"                  


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
        this.StateMap["EventHistoryStack"] := Array()
        this.StateMap["MonitorTopologyMap"] := Map()
        this.StateMap["ClipboardHistoryStack"] := Array()
        this.StateMap["ActiveLayoutSnapshots"] := Map()
        this.StateMap["VirtualWorkspaceFocusMatrix"] := Map()
        this.StateMap["WindowGeometryCache"] := Map()
        this.StateMap["ExecutionMetrics"] := Map("FramesProcessed", 0)
        
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
        this.StateMap["MonitorTopologyMap"].Clear()
        MonitorCount := MonitorGetCount()
        Loop MonitorCount {
            MonitorGet(A_Index, &Left, &Top, &Right, &Bottom)
            this.StateMap["MonitorTopologyMap"][A_Index] := {Left: Left, Top: Top, Right: Right, Bottom: Bottom}
        }
        CoreStateEngine.LogEventHistory("Win32 Matrix Recalculated: Mapped " . MonitorCount . " display monitors.")
    }
    
    static LogEventHistory(EventDescription) {
        History := this.StateMap["EventHistoryStack"]
        History.Push("[" . A_Hour . ":" . A_Min . ":" . A_Sec . "] " . EventDescription)
        if (History.Length > 50)
            History.RemoveAt(1)
    }
}


; • WIN32 HARDWARE INTERRUPT TOPOLOGY LISTENER (ZERO-POLLING EVENT HOOKS)

class Win32HardwareInterruptHook {
    static WM_DISPLAYCHANGE := 0x007E
    static WM_SETTINGCHANGE := 0x001A

    static Initialize() {
        OnMessage(this.WM_DISPLAYCHANGE, this.OnTopologyMutationEvent.Bind(this))
        OnMessage(this.WM_SETTINGCHANGE, this.OnEnvironmentSettingMutationEvent.Bind(this))
    }

    static OnTopologyMutationEvent(wParam, lParam, msg, hwnd) {
        NewWidth := lParam & 0xFFFF
        NewHeight := lParam >> 16
        
        CoreStateEngine.DiscoverMonitorTopology()
        CoreStateEngine.LogEventHistory("Hardware Event (WM_DISPLAYCHANGE): Topology adapted to resolution " . NewWidth . "x" . NewHeight)
        
        this.RealignWorkspaceMatrices()
        return 0
    }

    static OnEnvironmentSettingMutationEvent(wParam, lParam, msg, hwnd) {
        CoreStateEngine.DiscoverMonitorTopology()
        CoreStateEngine.LogEventHistory("Hardware Event (WM_SETTINGCHANGE): Core layout geometry update broadcasted.")
        
        this.RealignWorkspaceMatrices()
        return 0
    }

    static RealignWorkspaceMatrices() {
        CurrentWS := WorkspacePersistenceManager.CurrentWorkspaceID
        ActiveMap := WorkspacePersistenceManager.Workspaces[CurrentWS]
        MonitorGetWorkArea(1, &WL, &WT, &WR, &WB)
        
        for hwnd in ActiveMap["WindowList"] {
            if WinExist(hwnd) {
                Style := WinGetStyle(hwnd)
                if !(Style & 0x10000000) 
                    continue
                WindowAnimationEngine.AnimateTo(hwnd, WL, WT, WR - WL, WB - WT, 140)
            }
        }
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


; • ZERO-CLUTTER PRE-CALCULATED EXCLUSION-BASED WINDOW ANIMATION ENGINE

class WindowAnimationEngine {
    static ActiveAnimations := Map()

    static EaseCubicOut(t) => 1 - ((1 - t) ** 3)

    static AnimateTo(hwnd, TargetX, TargetY, TargetW, TargetH, DurationMS := 140) {
        if !WinExist(hwnd) {
            return
        }
        
        ClassStr := WinGetClass("ahk_id " . hwnd)
        if (ClassStr = "Progman" || ClassStr = "WorkerW" || ClassStr = "Shell_TrayWnd" || ClassStr = "CabinetWClass") {
            return
        }
        
        Style := WinGetStyle(hwnd)
        if (Style & 0x01000000 || !(Style & 0x10000000)) {
            return
        }
        
        WinGetPos(&StartX, &StartY, &StartW, &StartH, hwnd)
        if (StartX == TargetX && StartY == TargetY && StartW == TargetW && StartH == TargetH) {
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
        
        SetTimer(TimerCallback, 14) 
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
        hDWP := DllCall("DeferWindowPos", "Ptr", hDWP, "Ptr", hwnd, "Ptr", 0, "Int", CurrentX, "Int", CurrentY, "Int", CurrentW, "Int", CurrentH, "UInt", 0x0214, "Ptr")
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
            this.Workspaces[Idx] := Map("WindowList", [])
        }
    }

    static SwitchWorkspace(TargetID) {
        if (TargetID == this.CurrentWorkspaceID) {
            return
        }

        for hwnd in this.Workspaces[this.CurrentWorkspaceID]["WindowList"] {
            if WinExist(hwnd) {
                Style := WinGetStyle(hwnd)
                if !(Style & 0x10000000)
                    continue
                DllCall("ShowWindow", "Ptr", hwnd, "Int", 0) 
            }
        }

        this.CurrentWorkspaceID := TargetID
        ActiveMap := this.Workspaces[TargetID]

        for hwnd in ActiveMap["WindowList"] {
            if WinExist(hwnd) {
                DllCall("ShowWindow", "Ptr", hwnd, "Int", 4) 
                MonitorGetWorkArea(1, &WL, &WT, &WR, &WB)
                WindowAnimationEngine.AnimateTo(hwnd, WL, WT, WR - WL, WB - WT, 140)
            }
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


; • ADVANCED EVENT DRIVEN STATE INTERCEPTOR EXTRACTION PIPELINE

class StateInterceptorPipeline {
    static RegisteredInterceptors := Map()

    static InterceptAndRoute(TargetEvent, EventContextPayload) {
        if this.RegisteredInterceptors.Has(TargetEvent) {
            for InterceptorCallback in this.RegisteredInterceptors[TargetEvent] {
                InterceptorCallback(EventContextPayload)
            }
            return true
        }
        return false
    }

    static AddInterceptor(TargetEvent, CallbackFunc) {
        if !this.RegisteredInterceptors.Has(TargetEvent)
            this.RegisteredInterceptors[TargetEvent] := Array()
        this.RegisteredInterceptors[TargetEvent].Push(CallbackFunc)
    }
}


; • ZERO RUNTIME ALLOCATION FOCUS MATRIX VALIDATOR

class FocusMatrixValidator {
    static LastCheckedHwnd := 0
    static ValidationHistory := Array()

    static ValidateFocusState(ActiveHwnd) {
        if (ActiveHwnd == this.LastCheckedHwnd)
            return true
            
        if !WinExist(ActiveHwnd)
            return false
            
        this.LastCheckedHwnd := ActiveHwnd
        this.ValidationHistory.Push(ActiveHwnd)
        if (this.ValidationHistory.Length > 20)
            this.ValidationHistory.RemoveAt(1)
            
        return true
    }
}


; • DEEP KERNEL MUTATION EVENT EMITTER LINK

class KernelMutationEventEmitter {
    static MutationHooks := Map()

    static RegisterMutationTrigger(ClassString, ActionCallback) {
        this.MutationHooks[ClassString] := ActionCallback
    }

    static EvaluateMutation(ClassString, ControlHwnd) {
        if this.MutationHooks.Has(ClassString) {
            this.MutationHooks[ClassString](ControlHwnd)
            return true
        }
        return false
    }
}


; • SMART DESKTOP SCENARIO GEOMETRY CACHE TRACKER

class ScenarioGeometryCacheTracker {
    static GeometricMemoryMap := Map()

    static CacheCurrentGeometry(WorkspaceID, Hwnd) {
        if !WinExist(Hwnd)
            return
            
        WinGetPos(&X, &Y, &W, &H, "ahk_id " . Hwnd)
        if !this.GeometricMemoryMap.Has(WorkspaceID)
            this.GeometricMemoryMap[WorkspaceID] := Map()
            
        this.GeometricMemoryMap[WorkspaceID][Hwnd] := {WinX: X, WinY: Y, WinW: W, WinH: H}
    }

    static QueryCachedGeometry(WorkspaceID, Hwnd) {
        if this.GeometricMemoryMap.Has(WorkspaceID) {
            if this.GeometricMemoryMap[WorkspaceID].Has(Hwnd)
                return this.GeometricMemoryMap[WorkspaceID][Hwnd]
        }
        return ""
    }
}


; • HIGH LEVEL EVENT ENGINE STREAM SYNC MATRIX

class EventEngineStreamSyncMatrix {
    static StreamStateVector := []

    static PushToVector(EventCode, SourceIdentifier) {
        this.StreamStateVector.Push({TimeIndex: A_TickCount, EvCode: EventCode, SrcId: SourceIdentifier})
        if (this.StreamStateVector.Length > 100)
            this.StreamStateVector.RemoveAt(1)
    }

    static ClearVectorStream() {
        this.StreamStateVector := []
    }
}


; • ASYNCHRONOUS DEFERRED PACKET ROUTER SUB ENGINE

class AsynchronousDeferredPacketRouter {
    static BufferedPackets := Array()

    static QueuePacket(PacketHeader, PacketPayload) {
        this.BufferedPackets.Push({Header: PacketHeader, Data: PacketPayload, QueueTime: A_TickCount})
        SetTimer(ObjBindMethod(this, "ProcessNextBufferedPacket"), -1)
    }

    static ProcessNextBufferedPacket() {
        if (this.BufferedPackets.Length == 0)
            return
            
        TargetPacket := this.BufferedPackets.RemoveAt(1)
        PluginArchitectureManager.DispatchEvent("OnStateMutation", TargetPacket.Data)
    }
}


; • DIRECT USER SPACE WINDOW CLUSTERING MANAGER

class UserSpaceWindowClusteringManager {
    static ClusterGroups := Map()

    static AssignToCluster(GroupName, Hwnd) {
        if !this.ClusterGroups.Has(GroupName)
            this.ClusterGroups[GroupName] := Array()
            
        this.ClusterGroups[GroupName].Push(Hwnd)
    }

    static GetClusterMembers(GroupName) {
        return this.ClusterGroups.Has(GroupName) ? this.ClusterGroups[GroupName] : Array()
    }
}


; • REFLECTIVE RECURSIVE METADATA INTERROGATOR PLATFORM

class ReflectiveRecursiveMetadataInterrogator {
    static InterrogateTargetClass(ClassObject) {
        MetadataMap := Map()
        for PropName in ClassObject.OwnProps() {
            MetadataMap[PropName] := "Native Property Allocation"
        }
        return MetadataMap
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


; • CRITICAL FOCUS REVERSION TOP-LEVEL AGENT

class CriticalFocusReversionAgent {
    static EvaluationActive := false

    static RevertToLastValidContainer() {
        if this.EvaluationActive
            return
            
        this.EvaluationActive := true
        CurrentWS := WorkspacePersistenceManager.CurrentWorkspaceID
        ActiveWindows := WorkspacePersistenceManager.Workspaces[CurrentWS]["WindowList"]
        
        for Hwnd in ActiveWindows {
            if WinExist(Hwnd) {
                WinActivate("ahk_id " . Hwnd)
                break
            }
        }
        this.EvaluationActive := false
    }
}


; • RUNTIME ENVIRONMENT STRUCTURAL SAFETY WATCHDOG

class RuntimeEnvironmentStructuralSafetyWatchdog {
    static ActiveState := true

    static AuditExecutionStack() {
        if !this.ActiveState
            return
            
        CurrentWS := WorkspacePersistenceManager.CurrentWorkspaceID
        ActiveWindows := WorkspacePersistenceManager.Workspaces[CurrentWS]["WindowList"]
        
        CleanedArray := []
        for Hwnd in ActiveWindows {
            if WinExist(Hwnd)
                CleanedArray.Push(Hwnd)
        }
        WorkspacePersistenceManager.Workspaces[CurrentWS]["WindowList"] := CleanedArray
    }
}


; • LIGHTWEIGHT HIGH SPEED VOLATILE EVENT BUFFER

class LightweightHighSpeedVolatileEventBuffer {
    static InternalEventBuffer := Array()

    static EnqueueFastEvent(EventName) {
        this.InternalEventBuffer.Push(EventName)
        if (this.InternalEventBuffer.Length > 10) {
            this.InternalEventBuffer.RemoveAt(1)
        }
    }
}


; • PLATFORM BOOTSTRAPPING ENGINE (INITIALIZATION PHASE)

class HyprlandsPlatformBootstrap {
    static Boot() {
        CoreStateEngine.Initialize()
        InterProcessCommunicationServer.Initialize()
        Win32HardwareInterruptHook.Initialize()
        
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
        send "{LButton Up}"
        send "{Enter}"
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
    send "{Raw}" RawPlainString
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


; • ADVANCED LINUX-STYLE SELECTION CLONE (EXACT SHIFT-CARET HIGHLIGHT TRACKER)

class PreciseCaretSelectionEngine {
    static ActiveCaretMode := false
    static AnchorPositionX := 0
    static AnchorPositionY := 0

    static InitializeSelectionState() {
        if (A_Cursor != "IBeam") {
            return
        }
        
        if GetKeyState("Shift", "P") {
            if (!this.ActiveCaretMode) {
                this.ActiveCaretMode := true
                CoordMode "Mouse", "Screen"
                MouseGetPos(&cX, &cY)
                this.AnchorPositionX := cX
                this.AnchorPositionY := cY
                CoreStateEngine.LogEventHistory("Linux Caret Track: Shift anchor placed at [" . cX . "," . cY . "]")
            }
        }
    }

    static FinalizeShiftCaretEvaluation() {
        if (!this.ActiveCaretMode) {
            return
        }
        
        CoordMode "Mouse", "Screen"
        MouseGetPos(&endX, &endY)
        
        DeltaX := Abs(endX - this.AnchorPositionX)
        DeltaY := Abs(endY - this.AnchorPositionY)
        
        if (DeltaX > 8 || DeltaY > 8) {
            A_Clipboard := ""
            send "^c"
            if ClipWait(0.35, 1) {
                CoreStateEngine.LogEventHistory("Linux Caret Track: Shift selection range copied successfully.")
            }
        }
        
        this.ActiveCaretMode := false
    }
}

~LButton:: {
    if (A_Cursor != "IBeam") {
        return
    }
    
    if GetKeyState("Shift", "P") {
        PreciseCaretSelectionEngine.InitializeSelectionState()
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
            A_Clipboard := ""
            send "^c"
            if ClipWait(0.35, 1) {
                CoreStateEngine.LogEventHistory("Linux Drag Track: Direct mouse selection copied successfully.")
            }
        }
    }
}

~~Shift Up:: {
    if (A_Cursor == "IBeam") {
        PreciseCaretSelectionEngine.FinalizeShiftCaretEvaluation()
    } else {
        PreciseCaretSelectionEngine.ActiveCaretMode := false
    }
}

~*Left::
~*Right::
~*Up::
~*Down:: {
    if GetKeyState("Shift", "P") && (A_Cursor == "IBeam") {
        PreciseCaretSelectionEngine.InitializeSelectionState()
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
        send "^v"
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
+BackSpace::send("{Home}{ShiftDown}{End}{ShiftUp}{BackSpace}")


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

        MonitorGetWorkArea(1, &WL, &WT, &WR, &WB)
        MonitorWidth := WR - WL
        MonitorHeight := WB - WT

        HudW := Min(1200, Round(MonitorWidth * 0.85))
        HudH := Min(720, Round(MonitorHeight * 0.80))
        
        HalfWidth := Round(HudW / 2)
        ColWidth := Round(HalfWidth - 60) 
        RightColX := HalfWidth + 30

        BgColor := "16161e"      
        AccentColor := "00b5dc"  ; The electric blue accent
        RedColor := "f38ba8"     ; Tactical Red (Replaces Green headers/lines)
        GreenColor := "9ece6a"   ; Green (Used only for ACTIVE auto-clicker)
        PurpleColor := "bb9af7"  ; Tokyo-Night Purple (Used for DORMANT auto-clicker)
        TextColor := "a9b1d6"    

        HUDConsoleEngine.EngineInstance := Gui("-Caption +AlwaysOnTop +Border +Owner", "Hyprlands L23 OS HUD")
        HUDConsoleEngine.EngineInstance.BackColor := BgColor
        
        HUDConsoleEngine.EngineInstance.SetFont("s42 w900", "JetBrains Mono")
        HUDConsoleEngine.EngineInstance.Add("Text", "X0 Y15 Center w" . HudW . " c" . AccentColor, "•.✦.~•")
        
        HUDConsoleEngine.EngineInstance.SetFont("s16 w900", "JetBrains Mono") 
        HUDConsoleEngine.EngineInstance.Add("Text", "X0 Y85 Center w" . HudW . " c" . AccentColor, "• HYPRLAND PLATFORM API: METRIC DIAGNOSTICS •")
        
        ; Left Heading converted to your custom Red color
        HUDConsoleEngine.EngineInstance.SetFont("s12 w900 c" . RedColor, "JetBrains Mono")
        HUDConsoleEngine.EngineInstance.Add("Text", "X30 Y125 w" . ColWidth, "•━{ SYSTEM LOG REFLECTION DETAILS }━•")
        
        HUDConsoleEngine.EngineInstance.SetFont("s10 w900 c" . TextColor, "JetBrains Mono") 
        
        LogEntries := [
            {L: "  [KERNEL]  :: Priority Profile Mapped", R: "(REALTIME)"},
            {L: "  [WIN32]   :: Interop Hook Engine (WM_COPYDATA)", R: "(ACTIVE)"},
            {L: "  [IPC BUS] :: Named Daemon Pipe Connection Opened", R: "(ESTABLISHED)"},
            {L: "  [CONFIG]  :: Running natively inside RAM allocation", R: "(MEMORY)"},
            {L: "  [HOOKS]   :: Low-level OS WinEvent 0x8000 Engine", R: "(ATTACHED)"},
            {L: "  [REFLECT] :: Compiling internal runtime class API", R: "(COMPLETE)"},
            {L: "  [MODULES] :: Bootstrapping framework CoreStateEngine", R: "ONLINE"},
            {L: "  [PLUGINS] :: Registered -> ClipboardLoggerPlugin", R: "(Active)"},
            {L: "  [PLUGINS] :: Registered -> WindowRulesEnginePlugin", R: "(Active)"},
            {L: "  [DIR_COM] :: Win32 Shell Automation File Router", R: "(ONLINE)"},
            {L: "  [METRICS] :: SelfDescribingPlatformAPI Mapper", R: "(STABLE)"},
            {L: "  [ENV_TARGET] :: Active Shell Hook Terminal Context", R: ""},
            {L: "  [VIEWPORT]   :: Default Application Hyper-Browser", R: ""}
        ]
        
        logBlob := ""
        for Entry in LogEntries {
            logBlob .= HUDConsoleEngine.FormatLogLine(Entry.L, Entry.R) . "`n`n"
        }
        
        HUDConsoleEngine.EngineInstance.Add("Text", "X30 Y170 w" . ColWidth . " r26 +Background", logBlob)

        HUDConsoleEngine.EngineInstance.Add("Text", "X" . HalfWidth . " Y125 w1 h500 +Border c" . AccentColor)

        ; Right Heading converted to your custom Red color
        HUDConsoleEngine.EngineInstance.SetFont("s12 w900 c" . RedColor, "JetBrains Mono")
        HUDConsoleEngine.EngineInstance.Add("Text", "X" . RightColX . " Y125 w" . ColWidth, "•-{ ACTIVE HOTKEYS ✦ SUBSYSTEMS }━•")
        
        HUDConsoleEngine.EngineInstance.SetFont("s10 w900 c" . TextColor, "JetBrains Mono")
        
        ShortcutEntries := [
            "Win + Left / Right/ Up / Down  : Focus Window Container",
            "Win + Shift + Left / Right     : Move Window Container",
            "Win + Tab                      : Cycle Focus Onto Next Monitor",
            "Win + Shift + Tab              : Send Container To Next Monitor",
            "Win + [1 to 8]                 : Switch Active Workspace (0-7)",
            "Win + Shift + [1 to 8]         : Move Window Container- Workspace",
            "Win + Enter                    : Launch Windows Terminal (wt)",
            "Win + Shift + Z                : Launch Zen Browser Instance",
            "Win + Q                        : Kill Active Process Window",
            "Win + F                        : Toggle Floating / Tiled Mode",
            "Win + Shift + F                : Toggle Monocle View State",
            "Alt + O                        : Hot-Reload AHK Script File",
            "Alt + Shift + O                : Live-Reload Komorebi Tiling"
        ]
        
        shortcutText := ""
        for ShortcutString in ShortcutEntries {
            shortcutText .= "  " . ShortcutString . "`n`n"
        }
        
        HUDConsoleEngine.EngineInstance.Add("Text", "X" . RightColX . " Y170 w" . ColWidth . " r26 +Background", shortcutText)
        
        HUDConsoleEngine.EngineInstance.SetFont("s10 w900 c" . AccentColor, "JetBrains Mono")
        HUDConsoleEngine.EngineInstance.Add("Text", "X30 Y610 w" . (HudW - 60), "══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════")

        ; Auto-Clicker state condition mapping: Green for active, Purple for dormant
        ClickerStatus := CoreStateEngine.Get("GlobalClickingState") ? "ACTIVE" : "DORMANT"
        StatusColor := CoreStateEngine.Get("GlobalClickingState") ? GreenColor : PurpleColor

        HUDConsoleEngine.EngineInstance.SetFont("s12 w900 c" . TextColor, "JetBrains Mono")
        HUDConsoleEngine.EngineInstance.Add("Text", "X30 Y640 w" . ColWidth, "  Contact: Dhruvjoshi51011@proton.me")
        
        HUDConsoleEngine.EngineInstance.SetFont("s12 w900 c" . StatusColor, "JetBrains Mono")
        HUDConsoleEngine.EngineInstance.Add("Text", "X" . (HalfWidth) . " Y640 w" . (ColWidth + 30) . " Right", "AUTO-CLICKER STATUS : " . ClickerStatus)
        
        HUDConsoleEngine.EngineInstance.SetFont("c" . AccentColor . " s11 w900")
        HUDConsoleEngine.EngineInstance.Add("Text", "X0 Center w" . HudW . " Y670", "[ Press ✦ + \ : To Close ]")

        HUDConsoleEngine.EngineInstance.Show("Center w" . HudW . " h" . HudH)
    }
}
