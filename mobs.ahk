#Requires AutoHotkey v2.0
#SingleInstance Force

MINECRAFT_WIN := "ahk_exe javaw.exe"
IsAutoClickActive := false

OnExit(StopAutoClick)

F8:: {
    if !WinExist(MINECRAFT_WIN) {
        MsgBox("Minecraft is not running.", "AFK Script", 48)
        return
    }

    global IsAutoClickActive := !IsAutoClickActive

    if IsAutoClickActive {
        SetTimer(ExecuteClick, 100)
        ShowTemporaryToolTip("[AutoClick] Enabled")
    } else {
        StopAutoClick()
    }
}

End:: {
    StopAutoClick()
    ExitApp()
}

ExecuteClick() {
    if !IsAutoClickActive
        return

    if !WinExist(MINECRAFT_WIN) {
        StopAutoClick()
        return
    }

    ControlClick(, MINECRAFT_WIN, , "Left", 1, "NA")
}

StopAutoClick(_exitReason?, _exitCode?) {
    global IsAutoClickActive := false

    SetTimer(ExecuteClick, 0)

    ShowTemporaryToolTip("[AutoClick] Disabled")
}

ShowTemporaryToolTip(Text, Duration := 2000) {
    ToolTip(Text)
    SetTimer(() => ToolTip(), -Duration)
}
