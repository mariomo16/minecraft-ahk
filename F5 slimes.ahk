#Requires AutoHotkey v2.0
#SingleInstance Force

; --- CONFIGURACIÓN DE COLORES ---
Global activado := false
Global ColorObjetivo := 0x036D76   ; Azul objetivo
Global ColorProhibido1 := 0x33EBCB ; Diamante 1
Global ColorProhibido2 := 0x65F5F0 ; NUEVO COLOR A IGNORAR
Global Variacion := 25           
Global Disparando := false

; --- PARÁMETROS DE MOVIMIENTO ---
Global OffsetVertical := 30     
Global Suavizado := 0.15        
Global MaxPasos := 5            

; --- SISTEMA DE MEMORIA RÍGIDA ---
Global VelocidadBarrido := 130   
Global DireccionBarrido := 1    
Global PixelesDesdeElCentro := 0 
Global LimitePixeles := 972     

; --- TECLAS DE CONTROL DE ALTURA ---
PgUp:: {
    Global OffsetVertical += 5
    ActualizarEstado("Mira más ABAJO | Offset: " . OffsetVertical)
}

PgDn:: {
    Global OffsetVertical -= 5
    ActualizarEstado("Mira más ARRIBA | Offset: " . OffsetVertical)
}

; --- ACTIVACIÓN ---
F5:: {
    Global activado := !activado
    if (activado) {
        Global PixelesDesdeElCentro := 0 
        ActualizarEstado("TORRETA CON DOBLE FILTRO: ON")
        SetTimer(BucleCombate, 1) 
    } else {
        PararDisparo()
        ActualizarEstado("SISTEMA: OFF")
        SetTimer(BucleCombate, 0)
        SetTimer(QuitarToolTip, 2000)
    }
}

BucleCombate() {
    Global activado, ColorObjetivo, ColorProhibido1, ColorProhibido2, Variacion, Disparando, OffsetVertical, Suavizado, MaxPasos
    Global DireccionBarrido, PixelesDesdeElCentro, LimitePixeles, VelocidadBarrido

    if !activado
        return

    CX := A_ScreenWidth // 2
    CY := A_ScreenHeight // 2
    Encontrado := false
    
    Loop MaxPasos {
        Radio := A_Index * 100 
        if PixelSearch(&EncontradoX, &EncontradoY, CX-Radio, CY-Radio, CX+Radio, CY+Radio, ColorObjetivo, Variacion) {
            
            ; --- FILTRO DE EXCLUSIÓN (Busca ambos colores prohibidos) ---
            if PixelSearch(&FakeX, &FakeY, EncontradoX-10, EncontradoY-10, EncontradoX+10, EncontradoY+10, ColorProhibido1, 20) 
            || PixelSearch(&FakeX, &FakeY, EncontradoX-10, EncontradoY-10, EncontradoX+10, EncontradoY+10, ColorProhibido2, 20) {
                continue ; Si encuentra cualquiera de los dos, ignora y sigue buscando
            }

            Encontrado := true
            break 
        }
    }

    if Encontrado {
        RelX := EncontradoX - CX
        RelY := (EncontradoY + OffsetVertical) - CY

        IntentoMoverX := Round(Max(Min(RelX * Suavizado, 80), -80))
        
        ; Muro invisible
        NuevaPos := PixelesDesdeElCentro + IntentoMoverX
        if (NuevaPos > LimitePixeles) {
            IntentoMoverX := LimitePixeles - PixelesDesdeElCentro
            PixelesDesdeElCentro := LimitePixeles
        } else if (NuevaPos < -LimitePixeles) {
            IntentoMoverX := -LimitePixeles - PixelesDesdeElCentro
            PixelesDesdeElCentro := -LimitePixeles
        } else {
            PixelesDesdeElCentro += IntentoMoverX
        }

        DllCall("mouse_event", "UInt", 0x0001, "Int", IntentoMoverX, "Int", Round(RelY * Suavizado), "UInt", 0, "UPtr", 0)

        if !Disparando {
            Click("Right Down")
            Global Disparando := true
        }
    } else {
        PararDisparo()
        
        ; Barrido ultra rápido
        MovimientoBarrido := VelocidadBarrido * DireccionBarrido
        ProximaPos := PixelesDesdeElCentro + MovimientoBarrido
        
        if (ProximaPos >= LimitePixeles) {
            DireccionBarrido := -1
            MovimientoBarrido := LimitePixeles - PixelesDesdeElCentro
        } else if (ProximaPos <= -LimitePixeles) {
            DireccionBarrido := 1
            MovimientoBarrido := -LimitePixeles - PixelesDesdeElCentro
        }

        PixelesDesdeElCentro += MovimientoBarrido
        DllCall("mouse_event", "UInt", 0x0001, "Int", MovimientoBarrido, "Int", 0, "UInt", 0, "UPtr", 0)
    }
}

PararDisparo() {
    Global Disparando
    if (Disparando) {
        Click("Right Up")
        Global Disparando := false
    }
}

ActualizarEstado(Texto) => (ToolTip(Texto), SetTimer(QuitarToolTip, 3000))
QuitarToolTip() => (ToolTip(), SetTimer(QuitarToolTip, 0))
End::ExitApp