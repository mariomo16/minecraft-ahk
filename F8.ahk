#Requires AutoHotkey v2.0
#SingleInstance Force

; Teclas: F8 para iniciar/parar | Fin (End) para cerrar el script
Global activado := false
ID_Minecraft := "ahk_exe javaw.exe"

F8:: {
    Global activado := !activado
    
    if (activado) {
        if WinExist(ID_Minecraft) {
            ToolTip("AUTOCLICK + PASO 125ms: ENCENDIDO")
            SetTimer(EjecutarClick, 100)      ; Clics constantes cada 100ms
            SetTimer(MoverseAFK, 60000)       ; Ciclo de movimiento cada 60s
        } else {
            MsgBox("Minecraft no detectado. Abre el juego primero.", "Error")
            Global activado := false
        }
    } else {
        ToolTip("MODO AFK: APAGADO")
        SetTimer(EjecutarClick, 0)
        SetTimer(MoverseAFK, 0)
    }
    SetTimer(() => ToolTip(), -2000)
}

EjecutarClick() {
    ; Envía clics de forma independiente sin bloquear el resto del script
    if WinExist(ID_Minecraft) {
        ControlClick(, ID_Minecraft, , "Left", 1, "NA")
    }
}

MoverseAFK() {
    if WinExist(ID_Minecraft) {
        ; --- PASO ADELANTE (W) ---
        ControlSend("{w down}", , ID_Minecraft)
        ; Suelta la W a los 125ms sin detener los clics
        SetTimer(() => ControlSend("{w up}", , ID_Minecraft), -125) 
        
        ; --- PAUSA Y PASO ATRÁS (S) ---
        ; Espera 1 segundo para estabilizarse antes de volver
        SetTimer(EjecutarPasoAtras, -1000) 
    }
}

EjecutarPasoAtras() {
    if WinExist(ID_Minecraft) {
        ; --- PASO ATRÁS (S) ---
        ControlSend("{s down}", , ID_Minecraft)
        ; Suelta la S a los 125ms sin detener los clics
        SetTimer(() => ControlSend("{s up}", , ID_Minecraft), -125)
    }
}

End::ExitApp