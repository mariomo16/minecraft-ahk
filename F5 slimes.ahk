#Requires AutoHotkey v2.0
#SingleInstance Force

global IsActive := false
global IsShooting := false
global TargetColor := 0x036D76
global ExcludedColor1 := 0x33EBCB
global ExcludedColor2 := 0x65F5F0
global ColorVariation := 25
global VerticalOffset := 30
global Smoothing := 0.15
global MaxSearchSteps := 5
global SweepSpeed := 130
global SweepDirection := 1
global PixelsFromCenter := 0
global PixelLimit := 972

PgUp:: {
    global VerticalOffset += 5
    ShowTemporaryToolTip("[Aim] Offset: " . VerticalOffset)
}

PgDn:: {
    global VerticalOffset -= 5
    ShowTemporaryToolTip("[Aim] Offset: " . VerticalOffset)
}

F5:: {
    global IsActive := !IsActive

    if IsActive {
        global PixelsFromCenter := 0
        SetTimer(CombatLoop, 1)
        ShowTemporaryToolTip("[Turret] Enabled")
    } else {
        StopShooting()
        SetTimer(CombatLoop, 0)
        ShowTemporaryToolTip("[Turret] Disabled")
    }
}

End:: {
    StopShooting()
    ExitApp()
}

CombatLoop() {
    if !IsActive
        return

    CenterX := A_ScreenWidth
    CenterY := A_ScreenHeight
    Found := false

    loop MaxSearchSteps {
        SearchRadius := A_Index * 100

        if !PixelSearch(&FoundX, &FoundY, CenterX - SearchRadius, CenterY - SearchRadius, CenterX + SearchRadius,
            CenterY + SearchRadius, TargetColor, ColorVariation)
            continue

        if PixelSearch(&_, &_, FoundX - 10, FoundY - 10, FoundX + 10, FoundY + 10, ExcludedColor1, 20)
        || PixelSearch(&_, &_, FoundX - 10, FoundY - 10, FoundX + 10, FoundY + 10, ExcludedColor2, 20)
            continue

        Found := true
        break
    }

    if Found {
        RelX := FoundX - CenterX
        RelY := (FoundY + VerticalOffset) - CenterY

        MoveX := Round(Max(Min(RelX * Smoothing, 80), -80))
        NextPos := PixelsFromCenter + MoveX

        if NextPos > PixelLimit {
            MoveX := PixelLimit - PixelsFromCenter
            global PixelsFromCenter := PixelLimit
        } else if NextPos < -PixelLimit {
            MoveX := -PixelLimit - PixelsFromCenter
            global PixelsFromCenter := -PixelLimit
        } else {
            global PixelsFromCenter += MoveX
        }

        DllCall("mouse_event", "UInt", 0x0001, "Int", MoveX, "Int", Round(RelY * Smoothing), "UInt", 0, "UPtr", 0)

        if !IsShooting {
            Click("Right Down")
            global IsShooting := true
        }
    } else {
        StopShooting()

        SweepMove := SweepSpeed * SweepDirection
        NextPos := PixelsFromCenter + SweepMove

        if NextPos >= PixelLimit {
            global SweepDirection := -1
            SweepMove := PixelLimit - PixelsFromCenter
        } else if NextPos <= -PixelLimit {
            global SweepDirection := 1
            SweepMove := -PixelLimit - PixelsFromCenter
        }

        global PixelsFromCenter += SweepMove
        DllCall("mouse_event", "UInt", 0x0001, "Int", SweepMove, "Int", 0, "UInt", 0, "UPtr", 0)
    }
}

StopShooting() {
    if IsShooting {
        Click("Right Up")
        global IsShooting := false
    }
}

ShowTemporaryToolTip(Text, Duration := 2000) {
    ToolTip(Text)
    SetTimer(() => ToolTip(), -Duration)
}
