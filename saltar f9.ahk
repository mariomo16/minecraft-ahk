#Requires AutoHotkey v2.0
#SingleInstance Force

; --- Configuración ---
Global activado := false
ID_Minecraft := "ahk_exe javaw.exe"
IntervaloClicDerecho := 125000 ; 125 segundos en milisegundos

F9:: {
    Global activado := !activado
    
    if (activado) {
        if WinExist(ID_Minecraft) {
            ToolTip("MACRO: ESPACIO + CLIC DER (125s) ACTIVADO")
            
            ; 1. Iniciar el bucle del Espacio (cada 50ms)
            SetTimer(MantenerEspacio, 50)
            
            ; 2. Iniciar el bucle del Clic Derecho (cada 125s)
            SetTimer(EjecutarClicDerecho, IntervaloClicDerecho)
            
            ; Opcional: Hacer un primer clic derecho nada más activar
            EjecutarClicDerecho() 
        } else {
            MsgBox("Minecraft no detectado. Abre el juego primero.", "Error")
            Global activado := false
        }
    } else {
        ToolTip("MACRO: DESACTIVADO")
        ; Detener ambos temporizadores
        SetTimer(MantenerEspacio, 0)
        SetTimer(EjecutarClicDerecho, 0)
        
        ; Asegurarse de soltar la tecla al apagar
        ControlSend("{Space Up}", , ID_Minecraft)
    }
    SetTimer(() => ToolTip(), -2000)
}

; Función para el Espacio (Salto/Nado infinito)
MantenerEspacio() {
    if WinExist(ID_Minecraft) {
        ControlSend("{Space Down}", , ID_Minecraft)
    }
}

; Función para el Clic Derecho (cada 125 segundos)
EjecutarClicDerecho() {
    if WinExist(ID_Minecraft) {
        ; Usamos ControlClick para el ratón
        ControlClick(, ID_Minecraft, , "Right", 1, "NA")
    }
}

; Tecla Fin para cerrar el script por completo
End:: {
    if WinExist(ID_Minecraft)
        ControlSend("{Space Up}", , ID_Minecraft)
    ExitApp()
}