#Requires AutoHotkey v2.0
#SingleInstance Force

SetWorkingDir(A_ScriptDir)

Global activado := false
Global NombreImagen := "pesca.png"
Global Estado := "Centro" 
Global AcumuladoX := 0, AcumuladoY := 0 
Global BalanceoX := 0, BalanceoY := 0
Global SiguienteMovimiento := 0
Global TotalPescados := 0.0 
Global SegundosTranscurridos := 0 

F6:: {
    Global activado := !activado
    if (activado) {
        if !FileExist(NombreImagen) {
            MsgBox("Error: Falta pesca.png")
            return
        }
        ActualizarToolTip()
        Global SiguienteMovimiento := A_TickCount + Random(3000, 12000)
        SetTimer(BuclePesca, 100)
        SetTimer(Cronometro, 1000)
    } else {
        SetTimer(BuclePesca, 0), SetTimer(Cronometro, 0)
        ToolTip("PESCA DETENIDA")
        SetTimer(QuitarToolTip, 2000)
    }
}

Cronometro() {
    Global SegundosTranscurridos
    SegundosTranscurridos++
    ActualizarToolTip()
}

ActualizarToolTip() {
    Global TotalPescados, SegundosTranscurridos, activado, Estado
    if !activado
        return
    T := SegundosTranscurridos
    Reloj := Format("{:02}:{:02}:{:02}", Floor(T/3600), Floor(Mod(T,3600)/60), Mod(T,60))
    ToolTip(Format("PESCA: ON | Peces: {:.2f} | Tiempo: {} | Posición: {}", TotalPescados, Reloj, Estado))
}

QuitarToolTip() => (ToolTip(), SetTimer(QuitarToolTip, 0))

BuclePesca() {
    Global activado, NombreImagen, Estado, AcumuladoX, AcumuladoY, BalanceoX, BalanceoY, SiguienteMovimiento, TotalPescados
    
    ; --- INICIO DEL TEMPORIZADOR DE SEGURIDAD ---
    InicioEspera := A_TickCount 

    Loop 1000 { ; Aumentamos el loop para que no muera antes de tiempo
        if !activado
            return
            
        ; --- COMPROBACIÓN 15 SEGUNDOS (Watchdog) ---
        if (A_TickCount - InicioEspera > 15000) {
            ; Si han pasado 15 seg sin detectar imagen, relanzamos
            PrepararRelanzamiento()
            return
        }

        ; --- MICRO-MOVIMIENTO ---
        if (A_TickCount > SiguienteMovimiento) {
            MX := Random(-35, 35), MY := Random(-20, 20)
            MoverSuave(MX, MY, 10, 15)
            BalanceoX += MX, BalanceoY += MY
            SiguienteMovimiento := A_TickCount + Random(3000, 12000)
        }

        ; --- DETECCIÓN DEL PEZ ---
        if ImageSearch(&EncontradoX, &EncontradoY, 0, 0, A_ScreenWidth, A_ScreenHeight, "*80 " . NombreImagen) {
            Click("Right")
            TotalPescados += 1.15
            Sleep(Random(100, 150))
            PrepararRelanzamiento()
            return
        }
        Sleep(100) 
    }
}

PrepararRelanzamiento() {
    Global Estado, AcumuladoX, AcumuladoY, BalanceoX, BalanceoY
    
    ; 1. Limpiar balanceo
    MoverSuave(-BalanceoX, -BalanceoY, 5, 15)
    BalanceoX := 0, BalanceoY := 0

    ; 2. Lógica de posiciones
    MovX := 0, MovY := 0
    if (Estado == "Centro") {
        AcumuladoX := Random(300, 420)
        AcumuladoY := Random(20, 40)
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
    if (X == 0 && Y == 0)
        return
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
        if !activado
            break
        if (A_Index == PuntoLanzar)
            Click("Right")

        PX := Round(RX / (Pasos - A_Index + 1))
        PY := Round(RY / (Pasos - A_Index + 1))
        DllCall("mouse_event", "UInt", 0x0001, "Int", PX, "Int", PY, "UInt", 0, "UPtr", 0)
        Sleep(Random(5, 8))
        RX -= PX, RY -= PY
    }
    
    if (activado && (RX != 0 || RY != 0))
        DllCall("mouse_event", "UInt", 0x0001, "Int", RX, "Int", RY, "UInt", 0, "UPtr", 0)
    
    Sleep(2200)
}

End::ExitApp