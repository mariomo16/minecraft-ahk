#Requires AutoHotkey v2.0
#SingleInstance Force

Global activado := false
ID_Minecraft := "ahk_exe javaw.exe"

F9:: {
    Global activado := !activado
    if (activado) {
        if WinExist(ID_Minecraft) {
            ToolTip("AFK INICIADO (Modo Segundo Plano)")
            ; Iniciamos el bucle
            SetTimer(EnviarAcciones, 50) 
        } else {
            MsgBox("Minecraft no detectado.")
            Global activado := false
        }
    } else {
        DetenerTodo()
    }
    SetTimer(() => ToolTip(), -2000)
}

EnviarAcciones() {
    if !activado
        return

    if WinExist(ID_Minecraft) {
        ; En lugar de "Down", enviamos un clic rápido y la tecla W
        ; El parámetro "NA" es crucial: evita que el ratón se bloquee
        ControlClick(, ID_Minecraft, , "Right", , "NA")
        ControlSend("{w down}", , ID_Minecraft)
    } else {
        DetenerTodo()
    }
}

DetenerTodo() {
    Global activado := false
    SetTimer(EnviarAcciones, 0)
    if WinExist(ID_Minecraft) {
        ControlSend("{w up}", , ID_Minecraft)
    }
    ToolTip("AFK: APAGADO")
}

End::ExitApp()