#Requires AutoHotkey v2.0
#SingleInstance Force

; Teclas: F7 para iniciar/parar | Fin (End) para cerrar el script
Global activado := false
ID_Minecraft := "ahk_exe javaw.exe"

F7:: {
    Global activado := !activado
    
    if (activado) {
        if WinExist(ID_Minecraft) {
            ToolTip("DERECHO MANTENIDO: ACTIVADO")
            ; Mantiene presionado el clic DERECHO
            ControlClick(, ID_Minecraft, , "Right", 1, "D NA")
        } else {
            MsgBox("Minecraft no detectado. Abre el juego primero.", "Error")
            Global activado := false
        }
    } else {
        ToolTip("DERECHO MANTENIDO: DESACTIVADO")
        ; Suelta el clic DERECHO
        ControlClick(, ID_Minecraft, , "Right", 1, "U NA")
    }
    SetTimer(() => ToolTip(), -2000)
}

End:: {
    ; Soltamos el clic derecho por seguridad antes de salir
    ControlClick(, ID_Minecraft, , "Right", 1, "U NA")
    ExitApp()
}