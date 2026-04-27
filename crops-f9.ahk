#Requires AutoHotkey v2.0
#SingleInstance Force

MINECRAFT_WIN := "ahk_exe javaw.exe"
IsAfkActive := false

OnExit(ReleaseKeys)

F9:: {
    if !WinExist(MINECRAFT_WIN) {
        MsgBox("Minecraft is not running.", "Crops Script", 48)
        return
    }

    global IsAfkActive := !IsAfkActive

    if IsAfkActive {
        ControlSend("{Blind}{w down}", , MINECRAFT_WIN)
        SetTimer(ExecuteAfkActions, 80)
        ShowTemporaryToolTip("[Crops] Enabled")
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
    global IsAfkActive := false

    SetTimer(ExecuteAfkActions, 0)

    if WinExist(MINECRAFT_WIN)
        ControlSend("{Blind}{w up}", , MINECRAFT_WIN)

    ShowTemporaryToolTip("[Crops] Disabled")
}

ReleaseKeys(_exitReason?, _exitCode?) {
    if WinExist(MINECRAFT_WIN)
        ControlSend("{Blind}{w up}", , MINECRAFT_WIN)
}

ShowTemporaryToolTip(Text, Duration := 2000) {
    ToolTip(Text)
    SetTimer(() => ToolTip(), -Duration)
}
