#Requires AutoHotkey v2.0
#SingleInstance Force

; Teclas: ~Ctrl para activar/desactivar (mantiene su función original)
; Fin (End) para cerrar el script por completo
Global activado := false
ID_Minecraft := "ahk_exe javaw.exe"

; El símbolo ~ permite que la tecla "pase a través" hacia el sistema/juego
~Ctrl:: {
    Global activado := !activado
    
    if (activado) {
        if WinExist(ID_Minecraft) {
            ToolTip("AUTOCLICK: ENCENDIDO")
            SetTimer(EjecutarClick, 100) 
        } else {
            ToolTip("ERROR: Minecraft no abierto")
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
        ControlClick(, ID_Minecraft, , "Left", 1, "NA")
    }
}

End::ExitApp