#Requires AutoHotkey v2.0
#SingleInstance Force

MINECRAFT_WIN := ""
IsAutoClickActive := false

OnExit(StopAutoClick)

F8:: {
    if !WinExist(MINECRAFT_WIN) {
        MsgBox("Minecraft is not running.", "Mobs Multi-instance Script", 48)
        return
    }

    global IsAutoClickActive := !IsAutoClickActive
    global MINECRAFT_WIN := "ahk_id" . WinExist("ahk_exe javaw.exe")

    if IsAutoClickActive {
        SetTimer(ExecuteClick, 100)
        ShowTemporaryToolTip("[Mobs Multi-instance] Enabled")
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

    ShowTemporaryToolTip("[Mobs Multi-instance] Disabled")
}

ShowTemporaryToolTip(Text, Duration := 2000) {
    ToolTip(Text)
    SetTimer(() => ToolTip(), -Duration)
}
