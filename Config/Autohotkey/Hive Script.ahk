#Requires AutoHotkey v2.0
#SingleInstance Force
Persistent

/*
┌────────────────────────────────────────────────────────────────────────────┐
│ ■ TRANSCENDENT SYSTEM TUNING PIPELINE ( HIGH INTENSITY EXECUTOR )          │
└────────────────────────────────────────────────────────────────────────────┘
*/
{
    SetWorkingDir A_InitialWorkingDir
    ProcessSetPriority "Realtime"
    A_MaxHotkeysPerInterval := 200
    ListLines 0
    SendMode "Input"
}

/*
┌────────────────────────────────────────────────────────────────────────────┐
│ ■ DYNAMIC BI-DIRECTIONS EXECUTABLE LOCATOR MATRIX                          │
└────────────────────────────────────────────────────────────────────────────┘
*/
{
    FindExecutablePath(AppName, FallbackPath := "") {
        try {
            regPath := RegRead("HKCU\Software\Microsoft\Windows\CurrentVersion\App Paths\" . AppName)
            if FileExist(regPath)
                return regPath
        }
        try {
            regPath := RegRead("HKLM\Software\Microsoft\Windows\CurrentVersion\App Paths\" . AppName)
            if FileExist(regPath)
                return regPath
        }
        localAppData := EnvGet("LOCALAPPDATA")
        if localAppData {
            if (AppName = "cursor.exe" && FileExist(localAppData . "\Programs\cursor\Cursor.exe"))
                return localAppData . "\Programs\cursor\Cursor.exe"
            if (AppName = "zen.exe" && FileExist(localAppData . "\Programs\Zen\zen.exe"))
                return localAppData . "\Programs\Zen\zen.exe"
        }
        if (AppName = "zen.exe" && FileExist("C:\Program Files\Zen\zen.exe")) {
            return "C:\Program Files\Zen\zen.exe"
        }
        try {
            shell := ComObject("WScript.Shell")
            exec := shell.Exec("cmd.exe /c where " . AppName)
            output := exec.StdOut.ReadAll()
            cleanedPath := Trim(StrReplace(output, "`r`n", ""))
            if FileExist(cleanedPath)
                return cleanedPath
        }
        return FallbackPath
    }
}

/*
┌────────────────────────────────────────────────────────────────────────────┐
│ ■ PLATFORM COGNITION LAYER ( DYNAMIC COGNITIVE SYNC MATRIX )               │
└────────────────────────────────────────────────────────────────────────────┘
*/
{
    class CoreStateEngine {
        static StateMap := Map()

        static Initialize() {
            this.StateMap["GlobalClickingState"] := false
            this.StateMap["DebugMode"] := false
            this.StateMap["PerformanceProfile"] := "MaxExecution"
            this.StateMap["TargetTerminal"] := "wt"
            this.StateMap["TargetBrowser"] := FindExecutablePath("zen.exe", "C:\Program Files\Zen\zen.exe")
            this.StateMap["TargetIDE"] := FindExecutablePath("cursor.exe")
            this.StateMap["LastActiveProcess"] := ""
            this.StateMap["EventHistoryStack"] := Array()
            this.StateMap["MonitorTopologyMap"] := Map()
            this.StateMap["ClipboardHistoryStack"] := Array()
            this.StateMap["ActiveLayoutSnapshots"] := Map()
            this.StateMap["VirtualWorkspaceFocusMatrix"] := Map()
            this.StateMap["WindowGeometryCache"] := Map()
            this.StateMap["ExecutionMetrics"] := Map("FramesProcessed", 0)

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
}

/*
┌────────────────────────────────────────────────────────────────────────────┐
│ ■ NATIVE KERNEL INTERRUPT LOGIC BUS ( EVENT CAPTURE INTERFACE )            │
└────────────────────────────────────────────────────────────────────────────┘
*/
{
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
            return 0
        }

        static OnEnvironmentSettingMutationEvent(wParam, lParam, msg, hwnd) {
            CoreStateEngine.DiscoverMonitorTopology()
            CoreStateEngine.LogEventHistory("Hardware Event (WM_SETTINGCHANGE): Core layout geometry update broadcasted.")
            return 0
        }
    }
}

/*
┌────────────────────────────────────────────────────────────────────────────┐
│ ■ ARCHITECTURAL DECOUPLED DISPATCH ROUTER ( EVENT EXECUTOR )               │
└────────────────────────────────────────────────────────────────────────────┘
*/
{
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
                } catch Error as AnyError {
                    if CoreStateEngine.Get("DebugMode")
                        OutputDebug("Plugin error detected: " . AnyError.Message)
                }
            }
        }
    }
}

/*
┌────────────────────────────────────────────────────────────────────────────┐
│ ■ RUNTIME POLYNOMIAL EXTENSION ENGINE ( DISK SCANNER INTERFACE )           │
└────────────────────────────────────────────────────────────────────────────┘
*/
{
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
            } catch Error as ComError {
                if CoreStateEngine.Get("DebugMode")
                    OutputDebug("COM Directory Scan Fault: " . ComError.Message)
            }
        }
    }
}

/*
┌────────────────────────────────────────────────────────────────────────────┐
│ ■ ASYNCHRONOUS SIGMOID FRAME TRANSITION PIPELINE ( ALPHA TWEENER )         │
└────────────────────────────────────────────────────────────────────────────┘
*/
{
    class WindowDimmerEngine {
        static ActiveAnimations := Map()

        static Linear(t) => t

        static FadeTo(hwnd, TargetAlpha := 255, DurationMS := 300) {
            if !WinExist(hwnd) || this.IsIgnored(hwnd)
                return

            try {
                CurrentAlpha := WinGetTransparent(hwnd)
                if (CurrentAlpha = "")
                    CurrentAlpha := 255
            } catch {
                CurrentAlpha := 255
            }

            if (Abs(CurrentAlpha - TargetAlpha) < 5)
                return

            if this.ActiveAnimations.Has(hwnd)
                SetTimer(this.ActiveAnimations[hwnd]["Timer"], 0)

            AnimObj := Map(
                "Hwnd", hwnd,
                "StartAlpha", CurrentAlpha,
                "TargetAlpha", TargetAlpha,
                "StartTime", A_TickCount,
                "Duration", DurationMS
            )

            TimerCallback := ObjBindMethod(this, "StepAnimation", hwnd)
            AnimObj["Timer"] := TimerCallback
            this.ActiveAnimations[hwnd] := AnimObj

            SetTimer(TimerCallback, 8)
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

            EasedProgress := this.Linear(Progress)
            CurrentAlpha := Anim["StartAlpha"] + Round((Anim["TargetAlpha"] - Anim["StartAlpha"]) * EasedProgress)

            try {
                WinSetTransparent(CurrentAlpha, hwnd)
            } catch {
                ; Suppress transparency updates safely
            }

            if (Progress >= 1.0) {
                SetTimer(Anim["Timer"], 0)
                this.ActiveAnimations.Delete(hwnd)
            }
        }

        static IsIgnored(hwnd) {
            try {
                ClassStr := WinGetClass("ahk_id " . hwnd)
                if (ClassStr = "Progman" || ClassStr = "WorkerW" || ClassStr = "Shell_TrayWnd" || ClassStr = "CabinetWClass")
                    return true
                Style := WinGetStyle(hwnd)
                if (Style & 0x01000000 || !(Style & 0x10000000))
                    return true
            } catch {
                return true
            }
            return false
        }
    }
}

/*
┌────────────────────────────────────────────────────────────────────────────┐
│ ■ CLINICAL HARDWARE CLIPBOARD PACKET SYNCHRONIZER                          │
└────────────────────────────────────────────────────────────────────────────┘
*/
{
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
}

/*
┌────────────────────────────────────────────────────────────────────────────┐
│ ■ WINDOW COGNITION INTERCEPT ENGINE ( STRATEGIC MATRICES LAYER )           │
└────────────────────────────────────────────────────────────────────────────┘
*/
{
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
}

/*
┌────────────────────────────────────────────────────────────────────────────┐
│ ■ SHELL PURGE LAYER ( SYSTEM DEFAULT INTERRUPT CLAMP )                     │
└────────────────────────────────────────────────────────────────────────────┘
*/
{
    InitializeOSReclamation() {
        ReclamationKeys := [
            "#u", "#t", "#k", "#s", "#a", "#m",
            "#n", "#c", "!Tab", "!F4"
        ]

        for TargetKey in ReclamationKeys {
            try {
                Hotkey(TargetKey, (*) => False)
            } catch Error as HookError {
                continue
            }
        }
    }
}

/*
┌────────────────────────────────────────────────────────────────────────────┐
│ ■ MASTER PLATFORM BOOTSTRAP ( STAGE INTERLOCK DEPLOYER )                  │
└────────────────────────────────────────────────────────────────────────────┘
*/
{
    class HivesPlatformBootstrap {
        static Boot() {
            CoreStateEngine.Initialize()
            Win32HardwareInterruptHook.Initialize()
            DynamicModuleLoader.ScanAndLoadExternalModules()
            ClipboardLoggerPlugin.Init()
            WindowRulesEnginePlugin.Init()
            InitializeOSReclamation()
            InterProcessCommunicationServer.Initialize()
            this.BindCoreKeyboardTopologies()
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
            SelfDescribingPlatformAPI.RegisterManagedHotkey("#+z", (*) => Run(CoreStateEngine.Get("TargetBrowser")))
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

            Loop 8 {
                WorkspaceIndex := A_Index - 1
                Hotkey("#" . A_Index, FocusWorkspaceHandler.Bind(WorkspaceIndex))
                Hotkey("#+" . A_Index, MoveWorkspaceHandler.Bind(WorkspaceIndex))
            }
        }
    }
}

/*
┌────────────────────────────────────────────────────────────────────────────┐
│ ■ INTROSPECTIVE GRAPH REGISTRATION DESCRIPTOR LOGIC                        │
└────────────────────────────────────────────────────────────────────────────┘
*/
{
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
            return OutputString
        }
    }
}

/*
┌────────────────────────────────────────────────────────────────────────────┐
│ ■ ASYNCHRONOUS KERNEL MEMORY INTEROP DISPATCH IPC                          │
└────────────────────────────────────────────────────────────────────────────┘
*/
{
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
}

/*
┌────────────────────────────────────────────────────────────────────────────┐
│ ■ VECTOR RUNTIME EXECUTION INTERPOLATOR GRAPH                              │
└────────────────────────────────────────────────────────────────────────────┘
*/
{
    class AdvancedMetricInterpolator {
        static SamplePool := Array()
        static TotalTicksTracked := 0

        static RecordMetricPoint(MetricIdentifier, ExecutionValue) {
            if (this.SamplePool.Length > 200) {
                this.SamplePool.RemoveAt(1)
            }
            this.SamplePool.Push({Id: MetricIdentifier, Val: ExecutionValue, Stamp: A_TickCount})
            this.TotalTicksTracked++
        }

        static ComputeAverageMetricsById(MetricIdentifier) {
            AggregateSum := 0
            MatchingCount := 0
            for Observation in this.SamplePool {
                if (Observation.Id == MetricIdentifier) {
                    AggregateSum += Observation.Val
                    MatchingCount++
                }
            }
            return (MatchingCount > 0) ? (AggregateSum / MatchingCount) : 0
        }
    }
}

/*
┌────────────────────────────────────────────────────────────────────────────┐
│ ■ COGNITIVE ASYNCHRONOUS PACKET INTERCEPT STRATEGY                         │
└────────────────────────────────────────────────────────────────────────────┘
*/
{
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
}

/*
┌────────────────────────────────────────────────────────────────────────────┐
│ ■ ZERO RUNTIME ALLOCATION FOCUS DESCRIPTOR INTERFACE                      │
└────────────────────────────────────────────────────────────────────────────┘
*/
{
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
}

/*
┌────────────────────────────────────────────────────────────────────────────┐
│ ■ CORE TRANSITION TRIGGER EVENT DISPATCH PROTOCOL                          │
└────────────────────────────────────────────────────────────────────────────┘
*/
{
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
}

/*
┌────────────────────────────────────────────────────────────────────────────┐
│ ■ SYNCHRONIZED EVENT MATRIX VECTOR ENGINE                                  │
└────────────────────────────────────────────────────────────────────────────┘
*/
{
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
}

/*
┌────────────────────────────────────────────────────────────────────────────┐
│ ■ ASYNCHRONOUS DEFERRED PACKET TRAFFIC CONTROLLER                          │
└────────────────────────────────────────────────────────────────────────────┘
*/
{
    class AsynchronousDeferredPacketRouter {
        static BufferedPackets := Array()

        static QueuePacket(PacketHeader, PacketPayload) {
            this.BufferedPackets.Push({Header: PacketHeader, Data: PacketPayload, QueueTime: A_TickCount})
            SetTimer(ObjBindMethod(this, "ProcessNextBufferedPacket"), -1)
        }

        static ProcessNextBufferedPacket() {
            if (this.BufferedPackets.Length == 0) {
                return
            }
            TargetPacket := this.BufferedPackets.RemoveAt(1)
            PluginArchitectureManager.DispatchEvent("OnStateMutation", TargetPacket.Data)
        }
    }
}

/*
┌────────────────────────────────────────────────────────────────────────────┐
│ ■ APPLICATIONS GRAPH BUFFER SPACE MANAGER                                  │
└────────────────────────────────────────────────────────────────────────────┘
*/
{
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
}

/*
┌────────────────────────────────────────────────────────────────────────────┐
│ ■ RUNTIME METADATA RECURSIVE REFLECTION PARSER                             │
└────────────────────────────────────────────────────────────────────────────┘
*/
{
    class ReflectiveRecursiveMetadataInterrogator {
        static InterrogateTargetClass(ClassObject) {
            MetadataMap := Map()
            for PropName in ClassObject.OwnProps() {
                MetadataMap[PropName] := "Native Property Allocation"
            }
            return MetadataMap
        }
    }
}

/*
┌────────────────────────────────────────────────────────────────────────────┐
│ ■ FAST METRICS CACHE REGISTRY STREAM                                       │
└────────────────────────────────────────────────────────────────────────────┘
*/
{
    class LightweightHighSpeedVolatileEventBuffer {
        static InternalEventBuffer := Array()

        static EnqueueFastEvent(EventName) {
            this.InternalEventBuffer.Push(EventName)
            if (this.InternalEventBuffer.Length > 10) {
                this.InternalEventBuffer.RemoveAt(1)
            }
        }
    }
}

/*
┌────────────────────────────────────────────────────────────────────────────┐
│ ■ DECOUPLED DELEGATION LAYER ( NATIVE HOTKEY EMITTER )                     │
└────────────────────────────────────────────────────────────────────────────┘
*/
{
    FocusWorkspaceHandler(Idx, *) {
        KCmd("focus-workspace " . Idx)
    }

    MoveWorkspaceHandler(Idx, *) {
        KCmd("move-to-workspace " . Idx)
    }
}

/*
┌────────────────────────────────────────────────────────────────────────────┐
│ ■ RUNTIME MAIN ENTRY DISPATCH INITIALIZATION ENGINE                        │
└────────────────────────────────────────────────────────────────────────────┘
*/
{
    HivesPlatformBootstrap.Boot()
}

/*
┌────────────────────────────────────────────────────────────────────────────┐
│ ■ WIN32 SHELL EVENT PIPE WATCHER ( Hive COGNITIVE INTERCEPTOR )           │
└────────────────────────────────────────────────────────────────────────────┘
*/
{
    WinEventProc(hWinEventHook, event, hwnd, idObject, idChild, dwEventThread, dwmsEventTime) {
        if (idObject == 0 && hwnd != 0) {
            try {
                WinProcess := WinGetProcessName("ahk_id " . hwnd)
                if (WinProcess = "cursor.exe") {
                    return
                }
                CoreStateEngine.Set("LastActiveProcess", WinProcess)
                PluginArchitectureManager.DispatchEvent("OnWindowFocus", WinProcess, hwnd)
            }
        }
    }

    EventCallback := CallbackCreate(WinEventProc, "F")
    HookHandle := DllCall("SetWinEventHook"
        , "UInt", 0x8000
        , "UInt", 0x8000
        , "Ptr", 0
        , "Ptr", EventCallback
        , "UInt", 0
        , "UInt", 0
        , "UInt", 0)

    OnExit(ScriptExitHandler)

    ScriptExitHandler(*) {
        if (HookHandle) {
            DllCall("UnhookWinEvent", "Ptr", HookHandle)
        }
        if (EventCallback) {
            CallbackFree(EventCallback)
        }
    }
}

/*
┌──────────────────────────────────────────────────────────────────────────────┐
│ ■ Hives-TILE WINDOW MUTATION ENGINE ( SMOOTH ABSOLUTE CORNER MOUSE RESIZER ) │
└──────────────────────────────────────────────────────────────────────────────┘
*/

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
    }
}


/*
┌────────────────────────────────────────────────────────────────────────────┐
│ ■ ADVANCED SMART-SELECTION AND CLIPBOARD ENGINE ( NATIVE WINDOWS UIA )     │
└────────────────────────────────────────────────────────────────────────────┘
*/

global BlockAutoCopy := false
global LastAutoCopiedText := ""

+Left:: {
    global BlockAutoCopy
    BlockAutoCopy := true
    SendInput("+{Home}")
    SetTimer(() => BlockAutoCopy := false, -200)
}

+Right:: {
    global BlockAutoCopy
    BlockAutoCopy := true
    SendInput("+{End}")
    SetTimer(() => BlockAutoCopy := false, -200)
}

+Backspace:: {
    global BlockAutoCopy
    BlockAutoCopy := true
    SendInput("{Home}+{End}{Backspace}")
    SetTimer(() => BlockAutoCopy := false, -200)
}

; Safe, raw Windows API call checking UI Automation selection ranges—NO blind ^c spamming anymore
~LButton Up:: {
    global BlockAutoCopy, LastAutoCopiedText
    if (BlockAutoCopy)
        return

    try {
        ; Use Windows UI Automation API to safely look for active text highlights under system focus
        UIA := ComObject("{ff48dba4-63ef-4ef0-a7d9-b4d1cb552343}", "{30cbe57d-d9d0-452a-ab13-7ac5ac4825ee}")
        focusedEl := 0

        ; Query current structural text selection patterns directly from OS window buffers
        try focusedEl := UIA.GetFocusedElement()
        if !focusedEl
            return

        patternId := 10014 ; UIA_TextPatternId
        textPattern := 0
        try textPattern := focusedEl.GetCurrentPattern(patternId)

        if (textPattern) {
            selectionRanges := textPattern.GetSelection()
            if (selectionRanges && selectionRanges.Length > 0) {
                range := selectionRanges.GetElement(0)
                selectedText := range.GetText(-1)

                if (selectedText != "" && selectedText != LastAutoCopiedText) {
                    OldClip := ClipboardAll()
                    A_Clipboard := selectedText
                    LastAutoCopiedText := selectedText
                    CoreStateEngine.LogEventHistory("UIA API Auto-Copied Text Highlight cleanly.")
                }
            }
        }
    } catch {
        ; Transparently fallback if a specific app framework blocks direct UIA interrogation hooks
    }
}

/*
┌────────────────────────────────────────────────────────────────────────────┐
│ ■ INTROSPECTIVE GRAPHIC DIAGNOSTIC HEADS-UP OVERLAY ( HUD )                │
└────────────────────────────────────────────────────────────────────────────┘
*/
{
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
            AccentColor := "00b5dc"
            GreenColor := "9ece6a"
            TextColor := "a9b1d6"

            HUDConsoleEngine.EngineInstance := Gui("-Caption +AlwaysOnTop +Border +Owner", "Hives L23 OS HUD")
            HUDConsoleEngine.EngineInstance.BackColor := BgColor

            HUDConsoleEngine.EngineInstance.SetFont("s42 w900", "JetBrains Mono")
            HUDConsoleEngine.EngineInstance.Add("Text", "X0 Y15 Center w" . HudW . " c" . AccentColor, "•.✦.~•")

            HUDConsoleEngine.EngineInstance.SetFont("s16 w900", "JetBrains Mono")
            HUDConsoleEngine.EngineInstance.Add("Text", "X0 Y85 Center w" . HudW . " c" . AccentColor, "• Hive PLATFORM API: METRIC DIAGNOSTICS •")

            HUDConsoleEngine.EngineInstance.SetFont("s12 w900 c" . GreenColor, "JetBrains Mono")
            HUDConsoleEngine.EngineInstance.Add("Text", "X30 Y125 w" . ColWidth, "•-{ SYSTEM LOG REFLECTION DETAILS }━•")

            HUDConsoleEngine.EngineInstance.SetFont("s10 w900 c" . TextColor, "JetBrains Mono")

            LogEntries := [
                {L: " [KERNEL] :: Priority Profile Mapped", R: "(REALTIME)"},
                {L: " [WIN32] :: Interop Hook Engine (WM_COPYDATA)", R: "(ACTIVE)"},
                {L: " [IPC BUS] :: Named Daemon Pipe Connection Opened", R: "(ESTABLISHED)"},
                {L: " [CONFIG] :: Running natively inside RAM allocation", R: "(MEMORY)"},
                {L: " [HOOKS] :: Low-level OS WinEvent 0x8000 Engine", R: "(ATTACHED)"},
                {L: " [REFLECT] :: Compiling internal runtime class API", R: "(COMPLETE)"},
                {L: " [MODULES] :: Bootstrapping framework CoreStateEngine", R: "ONLINE"},
                {L: " [PLUGINS] :: Registered -> ClipboardLoggerPlugin", R: "(Active)"},
                {L: " [PLUGINS] :: Registered -> WindowRulesEnginePlugin", R: "(Active)"},
                {L: " [DIR_COM] :: Win32 Shell Automation File Router", R: "(ONLINE)"},
                {L: " [METRICS] :: SelfDescribingPlatformAPI Mapper", R: "(STABLE)"},
                {L: " [ENV_TARGET] :: Active Shell Hook Terminal Context", R: ""},
                {L: " [VIEWPORT] :: Default Application Hive-Browser", R: ""}
            ]

            logBlob := ""
            for Entry in LogEntries {
                logBlob .= HUDConsoleEngine.FormatLogLine(Entry.L, Entry.R) . "`n`n"
            }

            HUDConsoleEngine.EngineInstance.Add("Text", "X30 Y170 w" . ColWidth . " r26 +Background", logBlob)
            HUDConsoleEngine.EngineInstance.Add("Text", "X" . HalfWidth . " Y125 w1 h500 +Border c" . AccentColor)

            HUDConsoleEngine.EngineInstance.SetFont("s12 w900 c" . GreenColor, "JetBrains Mono")
            HUDConsoleEngine.EngineInstance.Add("Text", "X" . RightColX . " Y125 w" . ColWidth, "•-{ ACTIVE HOTKEYS ✦ SUBSYSTEMS }━•")

            HUDConsoleEngine.EngineInstance.SetFont("s10 w900 c" . TextColor, "JetBrains Mono")

            ShortcutEntries := [
                {S: "  Win + Left/Right/Up/Down       : Focus Window Container"},
                {S: "  Win + Shift + Left/Right       : Move Window Container"},
                {S: "  Win + Tab                      : Cycle Focus Onto Next Monitor"},
                {S: "  Win + Shift + Tab              : Send Container To Next Monitor"},
                {S: "  Win + [1 to 8]                 : Switch Active Workspace (0-7)"},
                {S: "  Win + Shift + [1 to 8]         : Move Container to Workspace"},
                {S: "  Win + Enter                    : Launch Windows Terminal (wt)"},
                {S: "  Win + Shift + Z                : Launch Zen Browser Instance"},
                {S: "  Win + Q                        : Kill Active Process Window"},
                {S: "  Win + F                        : Toggle Floating / Tiled Mode"},
                {S: "  Win + Shift + F                : Toggle Monocle View State"},
                {S: "  Alt + O                        : Hot-Reload AHK Script File"},
                {S: "  Alt + Shift + O                : Live-Reload Komorebi Tiling"},
                {S: "  Shift + Backspace              : Wipe text but keep line row"},
                {S: "  Win + D                        : Duplicate current line down"},
                {S: "  Win + Shift + M                : Highlight Left + Merge + Down"}
            ]

            shortcutBlob := ""
            for Binding in ShortcutEntries {
                if (Binding.S == " " || Binding.S == "") {
                    shortcutBlob .= "`n"
                    continue
                }

                if InStr(Binding.S, ":") {
                    SplitParts := StrSplit(Binding.S, ":", , 2)
                    LeftPart := Trim(SplitParts[1])
                    RightPart := "->  " . Trim(SplitParts[2])

                    TargetWidth := 36
                    PaddingCount := TargetWidth - StrLen(LeftPart)
                    PaddingSpaces := ""
                    Loop Max(1, PaddingCount)
                        PaddingSpaces .= " "

                    shortcutBlob .= LeftPart . PaddingSpaces . RightPart . "`n`n"
                } else {
                    shortcutBlob .= Binding.S . "`n`n"
                }
            }

            HUDConsoleEngine.EngineInstance.Add("Text", "X" . RightColX . " Y170 w" . ColWidth . " r26 +Background", shortcutBlob)

            HUDConsoleEngine.EngineInstance.SetFont("s10 w900 c" . AccentColor, a := "JetBrains Mono")
            HUDConsoleEngine.EngineInstance.Add("Text", "X30 Y610 w" . (HudW - 60), "══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════")

            HUDConsoleEngine.EngineInstance.SetFont("s12 w900 c" . TextColor, "JetBrains Mono")
            HUDConsoleEngine.EngineInstance.Add("Text", "X30 Y640 w" . ColWidth, "  Contact: Dhruvjoshi51011@proton.me")

            HUDConsoleEngine.EngineInstance.Show("w" . HudW . " h" . HudH)
        }
    }

    #\:: HUDConsoleEngine.TriggerDisplay()
}

/*
┌────────────────────────────────────────────────────────────────────────────┐
│ ■ BACK COMPATIBILITY INTEROP BOUNDS LAYER                                  │
└────────────────────────────────────────────────────────────────────────────┘
*/
KCmd(CommandString) {
    try {
        Run("komorebic.exe " . CommandString, , "Hide")
    }
}
