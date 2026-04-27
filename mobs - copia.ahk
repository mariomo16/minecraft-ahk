#Requires AutoHotkey v2.0
#SingleInstance Force

; --- Configuración ---
Global activado := false
Global VentanaID := 0

F8:: {
    Global activado := !activado
    Global VentanaID
    
    if (activado) {
        ; Captura el ID de la ventana que tengas activa JUSTO AHORA
        VentanaID := WinExist("A") 
        
        ; Verificación de seguridad: ¿Es realmente Minecraft?
        clase := WinGetClass(VentanaID)
        if (clase = "LWJGL" || WinGetProcessName(VentanaID) = "javaw.exe") {
            ToolTip("AUTOCLICK ANCLADO: ENCENDIDO`nID: " VentanaID)
            SetTimer(EjecutarClick, 100)
        } else {
            MsgBox("Error: La ventana activa no parece ser Minecraft.", "Error")
            Global activado := false
            ToolTip()
        }
    } else {
        ToolTip("AUTOCLICK: APAGADO")
        SetTimer(EjecutarClick, 0)
    }
    SetTimer(() => ToolTip(), -2000)
}

EjecutarClick() {
    Global VentanaID
    ; Solo intenta clicar si la ventana guardada aún existe
    if WinExist(VentanaID) {
        ; "NA" permite enviar el click sin activar la ventana
        ControlClick(, "ahk_id " VentanaID, , "Left", 1, "NA")
    } else {
        ; Si cierras el Minecraft, el script se detiene
        Global activado := false
        SetTimer(EjecutarClick, 0)
        ToolTip("Ventana perdida. Autoclick detenido.")
        SetTimer(() => ToolTip(), -3000)
    }
}

End::ExitApp