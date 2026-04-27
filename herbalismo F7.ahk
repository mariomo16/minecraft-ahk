#Requires AutoHotkey v2.0
#SingleInstance Force
SetControlDelay -1 ; Mejora la fiabilidad de los clics en segundo plano

Global activado := false
ID_Minecraft := "ahk_exe javaw.exe"

F7:: {
    Global activado := !activado

    if (activado) {
        if WinExist(ID_Minecraft) {
            ToolTip("AFK INICIADO (Modo Segundo Plano)")
            ; Usamos 'NA' para que no necesite que la ventana esté activa
            ControlClick(, ID_Minecraft, , "Left", , "D NA")
            ControlSend("{d down}", , ID_Minecraft)
        } else {
            MsgBox("Minecraft no detectado.")
            activado := false
        }
    } else {
        DetenerTodo()
    }

    SetTimer(() => ToolTip(), -2000)
}

DetenerTodo() {
    Global activado := false
    if WinExist(ID_Minecraft) {
        ControlClick(, ID_Minecraft, , "Left", , "U NA")
        ControlSend("{d up}", , ID_Minecraft)
    }
    ToolTip("AFK: APAGADO")
    SetTimer(() => ToolTip(), -2000)
}

End::ExitApp()