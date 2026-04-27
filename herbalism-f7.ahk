#Requires AutoHotkey v2.0
#SingleInstance Force
SetControlDelay(-1)

MINECRAFT_WIN := "ahk_exe javaw.exe"
IsAfkActive := false

OnExit(StopAfk)

F7:: {
    if !WinExist(MINECRAFT_WIN) {
        MsgBox("Minecraft is not running.", "Herbalism Script", 48)
        return
    }

    global IsAfkActive := !IsAfkActive

    if IsAfkActive {
        ControlClick(, MINECRAFT_WIN, , "Left", 1, "D NA")
        ControlSend("{Blind}{d down}", , MINECRAFT_WIN)
        ShowTemporaryToolTip("[Herbalism] Enabled")
    } else {
        StopAfk()
    }
}

End:: {
    StopAfk()
    ExitApp()
}

StopAfk(_exitReason?, _exitCode?) {
    global IsAfkActive := false

    if WinExist(MINECRAFT_WIN) {
        ControlClick(, MINECRAFT_WIN, , "Left", 1, "U NA")
        ControlSend("{Blind}{d up}", , MINECRAFT_WIN)
    }

    ShowTemporaryToolTip("[Herbalism] Disabled")
}

ShowTemporaryToolTip(Text, Duration := 2000) {
    ToolTip(Text)
    SetTimer(() => ToolTip(), -Duration)
}
