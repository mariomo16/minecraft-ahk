#Requires AutoHotkey v2.0
#SingleInstance Force

MINECRAFT_WIN := "ahk_exe javaw.exe"
IsHoldingRight := false

OnExit(ReleaseRightClick)

F7:: {
    if !WinExist(MINECRAFT_WIN) {
        MsgBox("Minecraft is not running.", "Bubblegun Script", 48)
        return
    }

    global IsHoldingRight := !IsHoldingRight

    if IsHoldingRight {
        ControlClick(, MINECRAFT_WIN, , "Right", 1, "D NA")
        ShowTemporaryToolTip("[Bubblegun] Enabled")
    } else {
        ReleaseRightClick()
    }
}

End:: {
    ReleaseRightClick()
    ExitApp()
}

ReleaseRightClick(_exitReason?, _exitCode?) {
    global IsHoldingRight := false

    if WinExist(MINECRAFT_WIN)
        ControlClick(, MINECRAFT_WIN, , "Right", 1, "U NA")

    ShowTemporaryToolTip("[Bubblegun] Disabled")
}

ShowTemporaryToolTip(Text, Duration := 2000) {
    ToolTip(Text)
    SetTimer(() => ToolTip(), -Duration)
}
