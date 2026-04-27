#Requires AutoHotkey v2.0
#SingleInstance Force

; Teclas: F8 para iniciar/parar | Fin (End) para cerrar el script
Global activado := false
ID_Minecraft := "ahk_exe javaw.exe"

F8:: {
    Global activado := !activado
    
    if (activado) {
        ; Comprobar si Minecraft existe usando la función correcta: WinExist
        if WinExist(ID_Minecraft) {
            ToolTip("AUTOCLICK: ENCENDIDO")
            SetTimer(EjecutarClick, 100) ; Un clic cada 100ms
        } else {
            MsgBox("Minecraft no detectado. Abre el juego primero.", "Error")
            Global activado := false
        }
    } else {
        ToolTip("AUTOCLICK: APAGADO")
        SetTimer(EjecutarClick, 0)
    }
    SetTimer(() => ToolTip(), -2000)
}

EjecutarClick() {
    if WinExist(ID_Minecraft) {
        ; ControlClick envía el clic a la ventana aunque no tenga el foco
        ControlClick(, ID_Minecraft, , "Left", 1, "NA")
    }
}

End::ExitApp