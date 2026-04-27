#Requires AutoHotkey v2.0
#SingleInstance Force

; Variables persistentes
Global activado := false
Global pasoOcho := false 
Global ID_Minecraft := "ahk_exe javaw.exe"

; --- CONTROLES ---

F12:: {
    Global activado := !activado
    if (activado) {
        if (WinExist(ID_Minecraft)) {
            ToolTip("SISTEMA v11.4: ACTIVADO")
            SetTimer(EjecutarClick, 100) 
            SetTimer(ClicDerechoUnico, -4000) 
            SetTimer(AccionTeclaSiete, -30000)
            SetTimer(SecuenciaEspecial, 62000)
        } else {
            MsgBox("Minecraft no detectado.", "Error")
            Global activado := false
        }
    } else {
        DetenerTodo()
        ToolTip("SISTEMA: PAUSADO")
    }
    SetTimer(() => ToolTip(), -2000)
}

; --- FUNCIONES ---

EjecutarClick() {
    if (activado && WinExist(ID_Minecraft)) {
        ControlClick(, ID_Minecraft, , "Left", 1, "NA")
    }
}

ClicDerechoUnico() {
    if (activado && WinExist(ID_Minecraft)) {
        ControlClick(, ID_Minecraft, , "Right", 1, "NA")
    }
}

SecuenciaEspecial() {
    Global pasoOcho
    if (!activado || !WinExist(ID_Minecraft)) {
        return
    }

    SetTimer(EjecutarClick, 0) 
    teclaActual := (pasoOcho) ? "8" : "9"
    ControlSend(teclaActual, , ID_Minecraft)
    Sleep(300)
    ControlClick(, ID_Minecraft, , "Right", 1, "D NA")
    Sleep(2100) 
    ControlClick(, ID_Minecraft, , "Right", 1, "U NA")
    ControlSend("1", , ID_Minecraft)
    Sleep(300)
    
    if (activado) {
        SetTimer(EjecutarClick, 100)
        SetTimer(AccionTeclaSiete, -30000)
        if (pasoOcho) {
            SetTimer(ClicDerechoUnico, -5000)
        }
    }
    pasoOcho := !pasoOcho
}

AccionTeclaSiete() {
    if (!activado || !WinExist(ID_Minecraft)) {
        return
    }
    
    ; 1. Cambiamos al slot 7
    ControlSend("7", , ID_Minecraft)
    Sleep(100)
    
    ; 2. BUCLE DE REFUERZO: Enviamos 20 clics manuales (10 por segundo)
    ; Esto asegura que aunque el Timer principal falle, estos entren.
    Loop 20 {
        if (!activado) {
            break
        }
        ControlClick(, ID_Minecraft, , "Left", 1, "NA")
        Sleep(100)
    }
    
    ; 3. Volvemos al slot 1
    if (activado) {
        ControlSend("1", , ID_Minecraft)
    }
}

DetenerTodo() {
    Global activado := false
    SetTimer(EjecutarClick, 0)
    SetTimer(SecuenciaEspecial, 0)
    SetTimer(AccionTeclaSiete, 0)
    SetTimer(ClicDerechoUnico, 0)
    if (WinExist(ID_Minecraft)) {
        ControlClick(, ID_Minecraft, , "Left", 1, "U NA")
        ControlClick(, ID_Minecraft, , "Right", 1, "U NA")
    }
}

End:: {
    DetenerTodo()
    ExitApp
}