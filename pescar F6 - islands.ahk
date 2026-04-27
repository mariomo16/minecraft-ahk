#Requires AutoHotkey v2.0
#SingleInstance Force

SetWorkingDir(A_ScriptDir)

; --- VARIABLES GLOBALES ---
Global activado := false
Global NombreImagen := "pesca.png"
Global Estado := "Centro" 
Global AcumuladoX := 0, AcumuladoY := 0 
Global BalanceoX := 0, BalanceoY := 0
Global SiguienteMovimiento := 0
Global TotalPescados := 0
Global SegundosTranscurridos := 0 

; Variables de área (se calcularán dinámicamente)
Global CX1 := 0, CY1 := 0, CX2 := 0, CY2 := 0
Global IX1 := 0, IY1 := 0, IX2 := 0, IY2 := 0

F6:: {
    Global activado := !activado
    if (activado) {
        if !FileExist(NombreImagen) {
            MsgBox("Error: Falta pesca.png")
            return
        }
        
        ; --- RECALCULAR ÁREAS SEGÚN LA VENTANA ACTUAL ---
        if WinActive("ahk_exe javaw.exe") or WinActive("Minecraft") {
            WinGetClientPos(&OutX, &OutY, &OutW, &OutH, "A")
            Global CX1 := OutW * 0.25, CY1 := OutH * 0.25
            Global CX2 := OutW * 0.75, CY2 := OutH * 0.75
            Global IX1 := OutW * 0.50, IY1 := OutH * 0.50
            Global IX2 := OutW, IY2 := OutH
        } else {
            MsgBox("Por favor, activa la ventana de Minecraft antes de pulsar F6")
            Global activado := false
            return
        }

        CoordMode("Pixel", "Window")
        CoordMode("Mouse", "Window")
        
        ActualizarToolTip()
        Global SiguienteMovimiento := A_TickCount + Random(3000, 12000)
        SetTimer(BuclePesca, 10) 
        SetTimer(Cronometro, 1000)
    } else {
        SetTimer(BuclePesca, 0), SetTimer(Cronometro, 0)
        ToolTip("PESCA DETENIDA")
        SetTimer(QuitarToolTip, 2000)
    }
}

Cronometro() {
    Global SegundosTranscurridos
    SegundosTranscurridos := SegundosTranscurridos + 1
    ActualizarToolTip()
}

ActualizarToolTip() {
    Global TotalPescados, SegundosTranscurridos, activado, Estado
    if (!activado)
        return
    T := SegundosTranscurridos
    Reloj := Format("{:02}:{:02}:{:02}", Floor(T/3600), Floor(Mod(T,3600)/60), Mod(T,60))
    ToolTip(Format("PESCA: ON | Peces: {} | Tiempo: {} | Posición: {}", TotalPescados, Reloj, Estado))
}

QuitarToolTip() {
    ToolTip()
    SetTimer(QuitarToolTip, 0)
}

BuclePesca() {
    Global activado, NombreImagen, Estado, AcumuladoX, AcumuladoY, BalanceoX, BalanceoY, SiguienteMovimiento, TotalPescados
    Global CX1, CY1, CX2, CY2, IX1, IY1, IX2, IY2
    
    InicioEspera := A_TickCount 

    Loop 10000 {
        if (!activado)
            return
            
        ; SEGURIDAD: Solo funciona si Minecraft es la ventana activa
        if !WinActive("ahk_exe javaw.exe") and !WinActive("Minecraft")
            continue

        ; 1. Imagen en esquina inferior derecha
        if ImageSearch(&EncontradoX, &EncontradoY, IX1, IY1, IX2, IY2, "*100 " . NombreImagen) {
            Click("Right")
            TotalPescados := TotalPescados + 1
            Sleep(150)
            PrepararRelanzamiento()
            return
        }

        ; 2. Color en centro (Solo busca dentro de la ventana de Minecraft)
        if PixelSearch(&PX, &PY, CX1, CY1, CX2, CY2, 0xFB363A, 15) {
            Loop 4 {
                Click("Right")
                Sleep(250)
            }
            Sleep(500) 
            Click("Right")
            
            InicioEspera := A_TickCount 
            Sleep(200)
        }

        ; 3. Watchdog 15s
        if (A_TickCount - InicioEspera > 15000) {
            PrepararRelanzamiento()
            return
        }

        ; 4. Micro-movimiento
        if (A_TickCount > SiguienteMovimiento) {
            MX := Random(-35, 35), MY := Random(-20, 20)
            MoverSuave(MX, MY, 10, 15)
            BalanceoX += MX, BalanceoY += MY
            SiguienteMovimiento := A_TickCount + Random(3000, 12000)
        }
        Sleep(20) 
    }
}

PrepararRelanzamiento() {
    Global Estado, AcumuladoX, AcumuladoY, BalanceoX, BalanceoY
    MoverSuave(-BalanceoX, -BalanceoY, 6, 15)
    BalanceoX := 0, BalanceoY := 0

    MovX := 0, MovY := 0
    if (Estado == "Centro") {
        AcumuladoX := Random(300, 420), AcumuladoY := Random(20, 40)
        if (Random(1, 2) == 1) {
            Estado := "Derecha", MovX := AcumuladoX
        } else {
            Estado := "Izquierda", MovX := -AcumuladoX
        }
        MovY := (Random(1, 2) == 1) ? AcumuladoY : -AcumuladoY
        AcumuladoY := MovY
    } else {
        MovX := (Estado == "Derecha") ? -AcumuladoX : AcumuladoX
        MovY := -AcumuladoY
        Estado := "Centro"
        AcumuladoX := 0, AcumuladoY := 0
    }
    ActualizarToolTip()
    MoverYRelanzar(MovX, MovY)
}

MoverSuave(X, Y, Pasos, Vel) {
    if (X == 0 and Y == 0) {
        return
    }
    Loop Pasos {
        DllCall("mouse_event", "UInt", 0x0001, "Int", Round(X/Pasos), "Int", Round(Y/Pasos), "UInt", 0, "UPtr", 0)
        Sleep(Vel)
    }
}

MoverYRelanzar(X, Y) {
    Pasos := 12
    PuntoLanzar := Round(Pasos * 0.8)
    RX := X, RY := Y
    Loop Pasos {
        if (!activado)
            break
        if (A_Index == PuntoLanzar)
            Click("Right")
        PX := Round(RX / (Pasos - A_Index + 1)), PY := Round(RY / (Pasos - A_Index + 1))
        DllCall("mouse_event", "UInt", 0x0001, "Int", PX, "Int", PY, "UInt", 0, "UPtr", 0)
        Sleep(Random(6, 9))
        RX -= PX, RY -= PY
    }
    if (activado and (RX != 0 or RY != 0))
        DllCall("mouse_event", "UInt", 0x0001, "Int", RX, "Int", RY, "UInt", 0, "UPtr", 0)
    Sleep(2200)
}

End::ExitApp