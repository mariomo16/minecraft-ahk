#Requires AutoHotkey v2.0
#SingleInstance Force

; Teclas: F7 para iniciar/parar | Fin (End) para cerrar el script
Global activado := false
ID_Minecraft := "ahk_exe javaw.exe"

F7:: {
    Global activado := !activado
    
    if (activado) {
        if WinExist(ID_Minecraft) {
            ToolTip("ARCO SEGUNDO PLANO (F7): ACTIVADO")
            SetTimer(CicloArco, 10) ; Inicia el ciclo
        } else {
            MsgBox("Minecraft no detectado. Abre el juego primero.", "Error")
            Global activado := false
        }
    } else {
        ToolTip("ARCO SEGUNDO PLANO (F7): DESACTIVADO")
        SetTimer(CicloArco, 0)
        ; Forzar soltar el clic al apagar para evitar que se quede "tensado"
        PostMessage(0x0205, 0, 0, , ID_Minecraft) ; 0x0205 = WM_RBUTTONUP
    }
    SetTimer(() => ToolTip(), -2000)
}

CicloArco() {
    Global activado
    if (activado && WinExist(ID_Minecraft)) {
        ; 1. Enviar señal de presionar clic derecho (WM_RBUTTONDOWN = 0x0204)
        PostMessage(0x0204, 0x0002, 0, , ID_Minecraft)
        
        ; 2. Esperar el tiempo de carga solicitado (1.25 segundos)
        Sleep(1250)
        
        ; 3. Enviar señal de soltar clic derecho (WM_RBUTTONUP = 0x0205)
        PostMessage(0x0205, 0, 0, , ID_Minecraft)
        
        ; 4. Pausa de re-armado (mínima para que el juego registre el disparo)
        Sleep(150)
    }
}

End::ExitApp