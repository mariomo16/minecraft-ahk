#Requires AutoHotkey v2.0
#SingleInstance Force

MINECRAFT_WIN := "ahk_exe javaw.exe"
IsAfkActive := false

OnExit(ReleaseKeys)

F9:: {
    global IsAfkActive

    if !WinExist(MINECRAFT_WIN) {
        MsgBox("Minecraft is not running.", "AFK Script", 48)
        return
    }

    IsAfkActive := !IsAfkActive

    if IsAfkActive {
        ControlSend("{Blind}{w down}", , MINECRAFT_WIN)
        SetTimer(ExecuteAfkActions, 80)
        ShowTemporaryToolTip("[AFK] Enabled")
    } else {
        StopAfk()
    }
}

End:: {
    StopAfk()
    ExitApp()
}

ExecuteAfkActions() {
    if !IsAfkActive
        return

    if !WinExist(MINECRAFT_WIN) {
        StopAfk()
        return
    }

    ControlClick(, MINECRAFT_WIN, , "Right", 1, "NA")
}

StopAfk() {
    global IsAfkActive
    IsAfkActive := false

    SetTimer(ExecuteAfkActions, 0)

    if WinExist(MINECRAFT_WIN)
        ControlSend("{Blind}{w up}", , MINECRAFT_WIN)

    ShowTemporaryToolTip("[AFK] Disabled")
}

ReleaseKeys(_exitReason, _exitCode) {
    if WinExist(MINECRAFT_WIN)
        ControlSend("{Blind}{w up}", , MINECRAFT_WIN)
}

ShowTemporaryToolTip(Text, Duration := 2000) {
    ToolTip(Text)
    SetTimer(() => ToolTip(), -Duration)
}
