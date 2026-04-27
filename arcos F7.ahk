#Requires AutoHotkey v2.0
#SingleInstance Force

MINECRAFT_WIN := "ahk_exe javaw.exe"
IsBowActive := false

OnExit(StopBow)

F7:: {
    if !WinExist(MINECRAFT_WIN) {
        MsgBox("Minecraft is not running.", "Bow Script", 40)
        return
    }

    global IsBowActive := !IsBowActive

    if IsBowActive {
        SetTimer(BowCycle, 10)
        ShowTemporaryToolTip("[Bow] Enabled")
    } else {
        StopBow
    }
}

End:: {
    StopBow()
    ExitApp()
}

BowCycle() {
    if !IsBowActive
        return

    if !WinExist(MINECRAFT_WIN) {
        StopBow()
        return
    }

    PostMessage(0x0204, 0x0002, 0, , MINECRAFT_WIN)
    Sleep(1250)

    PostMessage(0x0205, 0, 0, , MINECRAFT_WIN)
    Sleep(150)
}

StopBow(_exitReason?, _exitCode?) {
    global IsBowActive := false

    SetTimer(BowCycle, 0)

    PostMessage(0x0205, 0, 0, , MINECRAFT_WIN)

    ShowTemporaryToolTip("[Bow] Disabled")
}

ShowTemporaryToolTip(Text, Duration := 2000) {
    ToolTip(Text)
    SetTimer(() => ToolTip(), -Duration)
}
