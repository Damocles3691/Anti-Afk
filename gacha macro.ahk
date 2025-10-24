#NoEnv
#SingleInstance Force
#MaxHotkeysPerInterval 99000000
#HotkeyInterval 99000000
#KeyHistory 0
ListLines Off
Process, Priority, , A
SetBatchLines, -1
SetKeyDelay, -1, -1
SetDefaultMouseSpeed, 1
SetWinDelay, -1
SetControlDelay, -1
SendMode Input

; code was not meant to be read, so its a mess

globalExample := "
(
; ---------------------[Webhook Integration]--------------------- 
;   If you want it to ping a discord webhook when you get the scroll,
;   enter your webhook in the webhook string below
;   change the boolean below to true

webhook := ""placeholder""
pingOnScroll := False

;   replace placeholder with your discord ID
;   example: ""<@541760070732742667>""

discordName := ""<@placeholder>""

;   If you want it to ping the webhook when it detects a server list change
;   or when an account dies
;   change the boolean below to true

pingOnServerListChange := False

; ---------------------[Legacy Settings]--------------------- 
;   Old settings, if something is breaking messing with these may fix
;   don't change them unless you know what you are doing

manuallyHoldF := False
legacyGachaMacro := False
)"

windowExample := "
(
; ---------------------[Username]--------------------- 
; replace placeholder with this windows account username
; mainly used for webhook pings

accountName := ""Placeholder""

; ---------------------[Scroll Detector]--------------------- 
;   Change the booleans below to ""true"" or ""false"", 
;   depending on what scrolls you want
;   if you for some reason want a different scroll,
;   add it yourself

Hoppa := True
Snarv := True
Perc := True

;   If you want it to menu when it finds the scroll you want,
;   change the boolean below to true
;   strongly recommended to keep this on

menuOnScroll := True 

;   If you want to pop the scroll you want when it is detected,
;   change the boolean below to true (wip)

useScroll := False

; ---------------------[Safety]--------------------- 
;   If you want the script to detect when an account has
;   died, set the boolean below to true
;   set spawn to flowerlight for least false positives
;   (detects if the account isn't at skycastle, if you have accounts spawned in
;   that aren't at skycastle, disable this on them)

wipeProtection := False

;   Stops the script from checking if the server isn't full
;   only disable this if you are in a server where people are
;   log switching a lot
;   (You probably shouldn't turn this off)

disableCheckList := False

; ---------------------[Silver]--------------------- 
;   Change the boolean below to True to menu when
;   an account runs out of silver
;   strongly recommended to keep this on
;   will flood your webhook if you turn it off
;   and keep pingNoSilver enabled

menuNoSilver := False

; ---------------------[Webhook Integration]--------------------- 
;   If you want it to ping the webhook when it detects a server list change
;   or when an account dies
;   change the boolean below to true

pingOnServerListChange := True
pingOnDeath := True
pingNoSilver := False
)"






; ---------------------[Actual Macro]--------------------- 

webhook := ""
pingOnScroll := False
discordName := ""
pingOnServerListChange := False
manuallyHoldF := False
legacyGachaMacro := False


settingsFolder := A_ScriptDir . "\Settings"

Loop, %settingsFolder%\*.txt
{
    if (A_LoopFileName != "Global.txt")
    {
        FileDelete, %A_LoopFilePath%
    }
}

sleep, 500


windowArray := []
tooltipText := ""
settingsFolder := A_ScriptDir . "\Settings"

globalSettings := settingsFolder . "\Global.txt"
 
FileRead, fileContents, %globalSettings%

if ErrorLevel
    {
        MsgBox, Global.txt not found.`nCreating a new Global.txt file...
    
        FileCreateDir, %settingsFolder%
    
        FileAppend, %globalExample%, %globalSettings%
        
        FileRead, fileContents, %globalSettings%
    }
    

WinGet, windows, List, ahk_class WINDOWSCLIENT

Loop, % windows
    {
        window := windows%A_Index%
        windowArray[A_Index] := window
        WinGetTitle, windowTitle, ahk_id %window%
        windowTitles%A_Index% := windowTitle
    
        WinActivate, ahk_id %window%
        WinWaitActive, ahk_id %window%, , 5
        WinMaximize, ahk_id %window%
    
        windowFile := settingsFolder . "\" . A_Index . ".txt"
    
        FileAppend, %windowExample%, %windowFile%
        
        FileCreateDir, %settingsFolder%  
    }

ToolTip,  F2 to start script, % A_ScreenWidth // 28, % A_ScreenHeight // 1.5, 2
sleep, 15
ToolTip,  F3 to reload script, % A_ScreenWidth // 28, % A_ScreenHeight // 1.45, 3
sleep, 15
ToolTip,  F4 to close script, % A_ScreenWidth // 28, % A_ScreenHeight // 1.408, 4
sleep, 15
ToolTip,  REMEMBER TO READ README, % A_ScreenWidth // 28, % A_ScreenHeight // 1.366, 5
sleep, 15
ToolTip,  Script made by .dont.blink., % A_ScreenWidth // 28, % A_ScreenHeight // 1.27, 7



SetTimer, UpdateTooltip, 100

getGlobalSettings() {
    global webhook, pingOnScroll, discordName, pingOnServerListChange,manuallyHoldF, legacyGachaMacro

    settingsFolder := A_ScriptDir . "\Settings"
    settingsFile := settingsFolder . "\Global.txt"

    if !FileExist(settingsFile) {
        MsgBox, The settings file for %activeWindow% does not exist.
        return
    }

    FileRead, settings, %settingsFile%
    
    lines := StrSplit(settings, "`n")

    for index, line in lines {
        line := Trim(line)
        
        if (line == "" or SubStr(line, 1, 1) == ";")
            continue

        if (InStr(line, "webhook")) {
            parts := StrSplit(line, " := ")
            webhook := parts[2]
        }
        else if (InStr(line, "pingOnScroll")) {
            pingOnScroll := (InStr(line, "True") ? True : False)
        }
        else if (InStr(line, "discordName")) {
            parts := StrSplit(line, " := ")
            discordName := parts[2]
        }
        else if (InStr(line, "pingOnServerListChange")) {
            pingOnServerListChange := (InStr(line, "True") ? True : False)
        }
        else if (InStr(line, "manuallyHoldF")) {
            manuallyHoldF := (InStr(line, "True") ? True : False)
        }
        else if (InStr(line, "legacyGachaMacro")) {
            legacyGachaMacro := (InStr(line, "True") ? True : False)
        }
    }

    msgScroll := (pingOnScroll ? "True" : "False")
    msgpingOnServerListChange := (pingOnServerListChange ? "True" : "False")
    msgmanuallyHoldF := (manuallyHoldF ? "True" : "False")
    msglegacyGachaMacro := (legacyGachaMacro ? "True" : "False")

    Tooltip, Global Settings:`n`n`Ping on Scroll: %msgScroll%`nPing on list change: %msgpingOnServerListChange%, % A_ScreenWidth, % A_ScreenHeight // 1.65, 12
}





UpdateTooltip:
{
    if (!LoopFlag) {
        WinGet, activeID, ID, A

        currentTooltip := ""
        Loop, % windows
        {
            window := windows%A_Index%
            if (activeID = window)
            {
                currentTooltip := A_Index
                break
            }
        }

        if (tooltipText != currentTooltip) {
            tooltipText := currentTooltip
            ToolTip, %tooltipText%, % A_ScreenWidth // 100, % A_ScreenHeight * 0.1, 10
        }
    }
}

robloxWindows := 0

activeWindow := 0

serverListChanged := False

hasPingedHoppa := False
hasPingedSnarv := False
hasPingedPerc := False

LoopFlag := False

accountName := "Placeholder"
Hoppa := False
Snarv := False
Perc := False
menuOnScroll := False
useScroll := False
wipeProtection := False
disableCheckList := False
menuNoSilver := False
pingOnServerListChange := False
pingOnDeath := False
pingNoSilver := False

#Persistent  ; Keep the script running

getWindowSettings() {
    global accountName, Hoppa, Snarv, Perc, menuOnScroll, useScroll, wipeProtection, disableCheckList, menuNoSilver, pingOnServerListChange, pingOnDeath, pingNoSilver, activeWindow

    settingsFolder := A_ScriptDir . "\Settings"
    settingsFile := settingsFolder . "\" . activeWindow . ".txt"

    if !FileExist(settingsFile) {
        MsgBox, The settings file for %activeWindow% does not exist.
        return
    }

    FileRead, settings, %settingsFile%
    
    lines := StrSplit(settings, "`n")

    for index, line in lines {
        line := Trim(line)
        
        if (line == "" or SubStr(line, 1, 1) == ";")
            continue

        if (InStr(line, "accountName")) {
            parts := StrSplit(line, " := ")
            accountName := parts[2]
        }
        else if (InStr(line, "Hoppa")) {
            Hoppa := (InStr(line, "True") ? True : False)
        }
        else if (InStr(line, "Snarv")) {
            Snarv := (InStr(line, "True") ? True : False)
        }
        else if (InStr(line, "Perc")) {
            Perc := (InStr(line, "True") ? True : False)
        }
        else if (InStr(line, "menuOnScroll")) {
            menuOnScroll := (InStr(line, "True") ? True : False)
        }
        else if (InStr(line, "useScroll")) {
            useScroll := (InStr(line, "True") ? True : False)
        }
        else if (InStr(line, "wipeProtection")) {
            wipeProtection := (InStr(line, "True") ? True : False)
        }
        else if (InStr(line, "disableCheckList")) {
            disableCheckList := (InStr(line, "True") ? True : False)
        }
        else if (InStr(line, "menuNoSilver")) {
            menuNoSilver := (InStr(line, "True") ? True : False)
        }
        else if (InStr(line, "pingOnServerListChange")) {
            pingOnServerListChange := (InStr(line, "True") ? True : False)
        }
        else if (InStr(line, "pingOnDeath")) {
            pingOnDeath := (InStr(line, "True") ? True : False)
        }
        else if (InStr(line, "pingNoSilver")) {
            pingNoSilver := (InStr(line, "True") ? True : False)
        }
    }

    msgHoppa := (Hoppa ? "True" : "False")
    msgSnarv := (Snarv ? "True" : "False")
    msgPerc := (Perc ? "True" : "False")
    msgMenuOnScroll := (menuOnScroll ? "True" : "False")
    msgUseScroll := (useScroll ? "True" : "False")
    msgWipeProtection := (wipeProtection ? "True" : "False")
    msgDisableCheckList := (disableCheckList ? "True" : "False")
    msgMenuNoSilver := (menuNoSilver ? "True" : "False")
    msgPingOnServerListChange := (pingOnServerListChange ? "True" : "False")
    msgPingOnDeath := (pingOnDeath ? "True" : "False")
    msgPingNoSilver := (pingNoSilver ? "True" : "False")
    msgDisableCheckList := (disableCheckList ? "True" : "False")

    Tooltip, Settings loaded for %accountName%`n`n`Hoppa: %msgHoppa%`nSnarv: %msgSnarv%`nPerc: %msgPerc%`n`nmenuOnScroll: %msgMenuOnScroll%`nuseScroll: %msgUseScroll%`nwipeProtection: %msgWipeProtection%`ndisableCheckList: %msgDisableCheckList%`nmenuNoSilver: %msgMenuNoSilver%`n`npingOnServerListChange: %msgPingOnServerListChange%`npingOnDeath: %msgPingOnDeath%`npingNoSilver: %msgPingNoSilver%, % A_ScreenWidth, % A_ScreenHeight, 11

}


webhookSend(reason := "", godspell := ""){
    global webhook, accountName

    Send, !{PrintScreen}
    Sleep, 500

    FilePath := A_ScriptDir . "\\Screenshot.png"
    RunWait, PowerShell -Command "Add-Type -AssemblyName System.Windows.Forms; $clipboard = [Windows.Forms.Clipboard]::GetImage(); $clipboard.Save('%FilePath%')"

    webhookURL := webhook
    imagePath := FilePath

    url := webhookURL

    if (reason == "godspell") {
        postContent := accountName . " Has rolled " . godspell . "!"
    }
    else if (reason == "silver") {
        postContent := accountName . " has No Silver! Menuing"
    }
    else if (reason == "death") {
        postContent := accountName . " has likely died! Menuing all accounts"
    }
    else if (reason == "serverChange") {
        postContent := " Server list Change Detected! Menuing all accounts"
    }
    else if (reason == "noVind") {
        postContent := accountName . " at skycastle can't see Vind! Menuing"
    }

    ; userID := "USER_ID"  ; Replace with the actual Discord User ID
    ; mention := "%3C%40" . name . "%3E"  ; URL encode <@USER_ID> as %3C%40USER_ID%3E
    ; postContent := mention . " " . postContent

    ;postContent := name . " " . postContent

    curlCommand := "curl -X POST "
    curlCommand .= "--form ""content=" . postContent . """ "
    curlCommand .= "--form ""file=@" . imagePath . """ "
    curlCommand .= "--url """ . webhookURL . """" 

    RunWait, %comspec% /c %curlCommand%, , Hide

    return
}





checkNoSilver() {
CoordMode, Pixel, Screen
MenuImg := A_scriptDir . "\Images\Menu.png"
global webhook, discordName, pingNoSilver, menuNoSilver, manuallyHoldF
expectedColor := 0xFFFFFF

Sleep, 150
PixelGetColor, color1, 45, 1010, RGB
Sleep, 150
PixelGetColor, color2, 44, 1010, RGB
Sleep, 75

    if (color1 != expectedColor) {
        if (color2 != expectedColor) {
            ToolTip, 0 silver, % A_ScreenWidth // 28, % A_ScreenHeight // 2 

            if (menuNoSilver == true) {
                if (pingNoSilver == True){
                    webhookSend("silver", "null")
                }
                if (manuallyHoldF == False) { 
                    send, {f Up}
                    sleep, 150
                    send, {f Up}                    
                    sleep, 150
                    send, {f Down}
                    sleep, 150
                    send, {f Down}
                    Sleep, 300
                }
                ImageSearch, FoundX, FoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *50 %MenuImg%
                MouseMove, FoundX, FoundY + 10
                Sleep, 150
                ToolTip, 0 silver menuing, A_ScreenWidth // 28, % A_ScreenHeight // 2 
                send, {click}
                MouseMove, FoundX + 5, FoundY + 10
                Sleep, 150
                send, {click}
                Sleep, 500
            }
    } Else {
            ToolTip, above 250 silver, % A_ScreenWidth // 28, % A_ScreenHeight // 2 
        }
    } Else {
        ToolTip, above 250 silver, % A_ScreenWidth // 28, % A_ScreenHeight // 2 
    }
}

checkLowSilver() {
    CoordMode, Pixel, Screen
    expectedColor := 0xFDFDFD
    MenuImg := A_ScriptDir . "\Images\Menu.png"
    ImageSearch, FoundX, FoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *90 %MenuImg%
    if (ErrorLevel = 0){
        Sleep, 150
        PixelGetColor, color1, 45, 1017, RGB
        ToolTip, %color1% , % A_ScreenWidth // 28, % A_ScreenHeight // 2 
        ; MouseMove, 45, 1017
        Sleep, 75
        if (color1 != expectedColor) {
            ToolTip, less than 1000 silver , % A_ScreenWidth // 28, % A_ScreenHeight // 2 
            Sleep, 150
            checkNoSilver()
        
        }
        else {
            ToolTip, more than 1000 silver, % A_ScreenWidth // 28, % A_ScreenHeight // 2 
        }
    }
}
    

antiAFK() {
    ToolTip,  Running anti-AFK, A_ScreenWidth // 28, % A_ScreenHeight // 2 
    Loop, 3 {
        send, {space}
        sleep, 75
    }
}
 
checkInventory() {
    global Hoppa, Perc, Snarv, menuOnScroll, pingOnScroll, webhook, hasPingedPerc, hasPingedHoppa, hasPingedSnarv, discordName, manuallyHoldF

    scriptDir := A_ScriptDir
    HoppaImg := scriptDir . "\Images\Hoppa.png"
    MenuImg := scriptDir . "\Images\Menu.png"
    SnarvImg := scriptDir . "\Images\Snarv.png"
    PercImg := scriptDir . "\Images\Perc.png"
        
    CoordMode, Pixel, Screen
    CoordMode, Mouse, Screen
    send, ``
    Sleep, 70
    if (Hoppa == True) {
        ToolTip, Checking Inventory for Hoppa, A_ScreenWidth // 28, % A_ScreenHeight // 2 
        sleep, 300
        ImageSearch, FoundX, FoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *50 %HoppaImg%
        if (ErrorLevel = 0) {
            if (menuOnScroll == True) {
                if (pingOnScroll == True && hasPingedHoppa == False) {
                    webhookSend("godspell", "Hoppa")
                }
                if (manuallyHoldF == False) { 
                    send, {f Up}
                    sleep, 150
                    send, {f Up}
                    sleep, 150
                    send, {f Down}
                    sleep, 150
                    send, {f Down}
                    Sleep, 300
                }
                ImageSearch, FoundX, FoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *50 %MenuImg%
                MouseMove, FoundX, FoundY
                Sleep, 150
                ToolTip, Hoppa Found! Menuing!, A_ScreenWidth // 28, % A_ScreenHeight // 2 
                send, {click}
                MouseMove, FoundX + 5, FoundY
                Sleep, 150
                send, {click}
                Sleep, 5000
                Return
            }
        }
    }
    if (Snarv == True) {
        ToolTip, Checking Inventory for Snarv, A_ScreenWidth // 28, % A_ScreenHeight // 2 
        sleep, 300
        ImageSearch, FoundX, FoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *50 %SnarvImg%
        if (ErrorLevel = 0) {
            if (menuOnScroll == True) {
                if (pingOnScroll == True && hasPingedSnarv == False) {
                    webhookSend("godspell", "Snarvindur")
                }

                if (manuallyHoldF == False) { 
                    send, {f Up}
                    sleep, 150
                    send, {f Up}
                    sleep, 150
                    send, {f Down}
                    sleep, 150
                    send, {f Down}
                    Sleep, 300
                }
                ImageSearch, FoundX, FoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *50 %MenuImg%
                MouseMove, FoundX, FoundY
                Sleep, 150
                ToolTip, Snarv Found! Menuing!, A_ScreenWidth // 28, % A_ScreenHeight // 2 
                send, {click}
                MouseMove, FoundX + 5, FoundY
                Sleep, 150
                send, {click}
                Sleep, 5000
                Return
            }
        }
    }
    if (Perc == True) {
        ToolTip, Checking Inventory for Perc, A_ScreenWidth // 28, % A_ScreenHeight // 2 
        sleep, 300
        ImageSearch, FoundX, FoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *50 %PercImg%
        if (ErrorLevel = 0) {
            if (menuOnScroll == True) {
                if (pingOnScroll == True && hasPingedPerc == False) {
                    webhookSend("godspell", "Percutiens")
                }

                if (manuallyHoldF == False) { 
                    send, {f Up}
                    sleep, 150
                    send, {f Up}
                    sleep, 150
                    send, {f Down}
                    sleep, 150
                    send, {f Down}
                    Sleep, 300
                }
                ImageSearch, FoundX, FoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *50 %PercImg%
                MouseMove, FoundX, FoundY
                Sleep, 150
                ToolTip, Perc Found! Menuing!, A_ScreenWidth // 28, % A_ScreenHeight // 2 
                send, {click}
                MouseMove, FoundX + 5, FoundY
                Sleep, 150
                send, {click}
                Sleep, 5000
                Return
            }
        }
    }
    send, ``
}

checkWait() {
global disableCheckList

if (disableCheckList == False){
        ;ToolTip, Checking Server List , % A_ScreenWidth // 28, % A_ScreenHeight // 2 
        Sleep, 200

        global serverListChanged, webhook, pingOnServerListChange, manuallyHoldF

        MenuImg := A_ScriptDir . "\Images\Menu.png"
        CoordMode, Pixel, Client
        barColor := 0xA68665

        ; Check the colors at specified locations
        PixelGetColor, color, 1899, 291, RGB
        Sleep, 150
        PixelGetColor, color2, 1899, 200, RGB

        ; First condition to check if color2 doesn't match barColor
        ImageSearch, FoundX, FoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *90 %MenuImg%
        if (ErrorLevel = 0) {
            if (color2 != barColor) {
                ImageSearch, FoundX, FoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *90 %MenuImg%
                ToolTip, Non full server detected! Menuing , % A_ScreenWidth // 28, % A_ScreenHeight // 2 
                serverListChanged := True

                if (ErrorLevel = 0) {
                    if (pingOnServerListChange == True) {
                        webhookSend("serverChange", "null")
                    }
                    Sleep, 300
                    ; If ImageSearch succeeds, click the found location
                    if (manuallyHoldF == False) { 
                        send, {f Up}
                        sleep, 150
                        send, {f Up}
                        sleep, 150
                        send, {f Down}
                        sleep, 150
                        send, {f Down}
                        Sleep, 300
                    }
                    MouseMove, FoundX, FoundY + 24
                    Sleep, 150
                    send, {click}
                    MouseMove, FoundX + , FoundY + 24
                    Sleep, 150
                    send, {click}
                    Sleep, 500
                }
            }
            ; Second condition to check if color matches barColor, and if so, repeat the ImageSearch
            else if (color = barColor) {
                if (pingOnServerListChange == True) {
                    webhookSend("serverChange", "null")
                }
                Sleep, 300
                ImageSearch, FoundX, FoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *90 %MenuImg%
                ToolTip, Non full server detected! Menuing , % A_ScreenWidth // 28, % A_ScreenHeight // 2 
                serverListChanged := True

                if (ErrorLevel = 0) {
                    ; If ImageSearch succeeds, click the found location
                    if (manuallyHoldF == False) { 
                        send, {f Up}
                        sleep, 150
                        send, {f Up}
                        sleep, 150
                        send, {f Down}
                        sleep, 150
                        send, {f Down}
                        Sleep, 300
                    }
                    MouseMove, FoundX, FoundY + 24
                    Sleep, 150
                    send, {click}
                    MouseMove, FoundX + 1, FoundY + 24
                    Sleep, 150
                    send, {click}
                    Sleep, 500
                }
            }
        }
    }
    else{
        Sleep, 350
    }
}

gachaScript() {

    global robloxWindows, manuallyHoldF
    gachaSucess := False
    waitTime := 30000 / robloxWindows
    Sleep, 75
    waitTimeSeconds := Round(waitTime / 1000)
    ToolTip, Starting Gacha, A_ScreenWidth // 28, % A_ScreenHeight // 2 
    if (manuallyHoldF == False) { 
        send, {f Up}
        sleep, 150
        send, {f Down}
        Sleep, 300
    }

    CoordMode, Mouse, Screen
    loop, 10 {
        PixelSearch, x, y, 0, 0, A_ScreenWidth, A_ScreenHeight, 0xAE98EB, 3, Fast RGB
        MouseMove, x, y
        sleep, 1500
        MouseMove, x + 1, y + 1

        If (ErrorLevel == 0) {
            gachaSucess := True
            Sleep, 1000
            send, {click}
            Sleep, 3500
            MouseMove, 961, 598
            Sleep, 150
            MouseMove, 961, 596
            Sleep, 75
            send, {click}
            sleep, 5000
            MouseMove, 841, 863
            Sleep, 150
            MouseMove, 841, 861
            Sleep, 75
            send, {click}
            Sleep, 1000
            MouseMove, 839, 861
            Sleep, 75
            send, {click}
            Sleep, 500
            MouseMove, 839, 862
            Sleep, 2000
            send, {Click}
            Break
        }
        Sleep, 1000
    }

    if (gachaSucess == False) {
        ToolTip, Failed to start Gacha, A_ScreenWidth // 28, % A_ScreenHeight // 2 
    }
    Else {
        checkInventory()
        Sleep, 150
        if (manuallyHoldF == False) {
            send, {f Up}
            Sleep, 150

        }
        ToolTip, Waiting %waitTimeSeconds% seconds , A_ScreenWidth // 28, % A_ScreenHeight // 2 
        Loop, %waitTimeSeconds% {
            checkWait()
            Sleep, 650
        }
        checkLowSilver()
    }




}


; legacy gacha macro, leaving this in because it might still be useful
PerformClicks() {

    global robloxWindows, manuallyHoldF

    waitTime := 30000 / robloxWindows
    Sleep, 75
    waitTimeSeconds := Round(waitTime / 1000)

    Sleep, 75

    CoordMode, Mouse, Screen
    
        ToolTip, Running Gacha Macro, A_ScreenWidth // 28, % A_ScreenHeight // 2 
        Sleep, 150
        if (manuallyHoldF == False) { 
            send, {f Up}
            sleep, 150
            send, {f Down}
            Sleep, 300
        }
        MouseMove, 960, 530
        Sleep, 150
        send, {click}
        MouseMove, 960, 539
        Sleep, 150
        send, {click}
        Sleep, 4000
        MouseMove, 960, 583
        Sleep, 150
        send, {click}
        MouseMove, 966, 584
        Sleep, 150
        send, {click}
        Sleep, 7850
        MouseMove, 835, 865
        Sleep, 150
        send, {click}
        MouseMove, 850, 867
        Sleep, 150
        send, {click}
        Sleep, 3850
        MouseMove, 834, 865
        Sleep, 150
        send, {click}
        MouseMove, 837, 867
        Sleep, 150
        send, {click}
        sleep, 150
        if (manuallyHoldF == False) {
            send, {f Up}
            Sleep, 150
        }
        checkInventory()
        ToolTip, Waiting %waitTimeSeconds% seconds , A_ScreenWidth // 28, % A_ScreenHeight // 2 
        Loop, %waitTimeSeconds% {
            checkWait()
            Sleep, 650
        }
    }


checkVind() {
    global wipeProtection, serverListChanged, webhook, discordName, pingOnDeath, legacyGachaMacro, manuallyHoldF

    CoordMode, Pixel, Screen  ; Set PixelSearch to screen coordinates
    CoordMode, Mouse, Screen  ; Set MouseMove to screen coordinates

    MenuImg := A_ScriptDir . "\Images\Menu.png"

    ToolTip, Checking for Vind, A_ScreenWidth // 28, % A_ScreenHeight // 2 
    PixelSearch, x, y, 0, 0, A_ScreenWidth, A_ScreenHeight, 0xA891E7, 5, Fast RGB
    Sleep, 200

    if (ErrorLevel = 0) {
        ToolTip, Account at Skycastle running gacha script, A_ScreenWidth // 28, % A_ScreenHeight // 2 
        sleep, 200
        if (legacyGachaMacro == true) {
            PerformClicks()
        }
        Else {
            gachaScript()
        }

    } else {
        if (wipeProtection == true) {
            ToolTip, Vind not found running backup detection, A_ScreenWidth // 28, % A_ScreenHeight // 2 
            Sleep, 200
            CoordMode, Pixel, Relative  ; Switch PixelSearch to relative coordinates
            WinActivate, A
            WinGetPos, WinX, WinY, WinWidth, WinHeight, A
            StartX := 0
            StartY := 0
            EndX := WinWidth
            EndY := WinHeight

            PixelSearch, x, y, StartX, StartY, EndX, EndY, 0xE066A8, 15, Fast RGB
            MouseMove, x , y
            if (ErrorLevel = 0) {
                ToolTip, Account at Skycastle cant see vind, A_ScreenWidth // 28, % A_ScreenHeight // 2 
                Sleep, 200
                ;send webhook that an account cant see the vind?
                ImageSearch, FoundX, FoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *90 %MenuImg%
                Sleep, 15
                if (ErrorLevel = 0) {
                    webhookSend("noVind", "null")
                    if (manuallyHoldF == False) { 
                        send, {f Up}
                        sleep, 150
                        send, {f Up}
                        sleep, 150
                        send, {f Down}
                        sleep, 150
                        send, {f Down}
                        Sleep, 300
                    }
                    MouseMove, FoundX, FoundY
                    Sleep, 150
                    Send, {Click}
                    MouseMove, FoundX + 5, FoundY
                    Sleep, 150
                    Send, {Click}
                    Sleep, 500
                }

            } else {
                ToolTip, Account Has Likely died! Menuing all accounts!, A_ScreenWidth // 28, % A_ScreenHeight // 2 
                serverListChanged := true

                ImageSearch, FoundX, FoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *90 %MenuImg%
                Sleep, 15
                if (pingOnDeath == true) {
                    webhookSend("death", "null")
                }
                if (ErrorLevel = 0) {
                    if (manuallyHoldF == False) { 
                        send, {f Up}
                        sleep, 150
                        send, {f Up}
                        sleep, 150
                        send, {f Down}
                        sleep, 150
                        send, {f Down}
                        Sleep, 300
                    }
                    MouseMove, FoundX, FoundY
                    Sleep, 150
                    Send, {Click}
                    MouseMove, FoundX + 5, FoundY
                    Sleep, 150
                    Send, {Click}
                    Sleep, 500
                }
            }
        } else {
            ToolTip, Account not at Skycastle running anti-AFK, A_ScreenWidth // 28, % A_ScreenHeight // 2 
            Sleep, 200
            antiAFK()
        }
    }
}


;shoutout chat gpt for fixing this :skull:
checkList() {
global disableCheckList

if (disableCheckList == False)
    {
        ToolTip, Checking Server List , % A_ScreenWidth // 28, % A_ScreenHeight // 2 
        Sleep, 200

        global serverListChanged, webhook, pingOnServerListChange

        MenuImg := A_ScriptDir . "\Images\Menu.png"
        CoordMode, Pixel, Client
        barColor := 0xA68665

        ; Check the colors at specified locations
        PixelGetColor, color, 1899, 291, RGB
        Sleep, 150
        PixelGetColor, color2, 1899, 200, RGB

        ; First condition to check if color2 doesn't match barColor
        if (color2 != barColor) {
            ImageSearch, FoundX, FoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *90 %MenuImg%
            ToolTip, Non full server detected! Menuing , % A_ScreenWidth // 28, % A_ScreenHeight // 2 
            serverListChanged := True
            if (pingOnServerListChange == True) {
                webhookSend("serverChange", "null") 
            }
            Sleep, 300
            if (ErrorLevel = 0) {
                ; If ImageSearch succeeds, click the found location
                MouseMove, FoundX, FoundY
                Sleep, 150
                send, {click}
                MouseMove, FoundX + 5, FoundY
                Sleep, 150
                send, {click}
                Sleep, 500
            }
        }
        ; Second condition to check if color matches barColor, and if so, repeat the ImageSearch
        else if (color = barColor) {
            ImageSearch, FoundX, FoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *90 %MenuImg%
            ToolTip, Non full server detected! Menuing , % A_ScreenWidth // 28, % A_ScreenHeight // 2 
            serverListChanged := True

            if (pingOnServerListChange == True) {
                webhookSend("serverChange", "null") 
            }
            Sleep, 300

            if (ErrorLevel = 0) {
                ; If ImageSearch succeeds, click the found location
                MouseMove, FoundX, FoundY
                Sleep, 150
                send, {click}
                MouseMove, FoundX + 5, FoundY
                Sleep, 150
                send, {click}
                Sleep, 500
            }
        }
        ; If none of the above conditions were met, run checkVind()
        else {
            checkVind()
        }
    }Else{
        Sleep, 350
        checkVind()
    }
}



checkSpawned() {
    ToolTip, Checking If Spawned, % A_ScreenWidth // 28, % A_ScreenHeight // 2
    CoordMode, Mouse, Client
    CoordMode, Pixel, Client
    MenuImg := A_ScriptDir . "\Images\Menu.png"

    global serverListChanged, manuallyHoldF

    sleep, 500
    ImageSearch, FoundX, FoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *5 %MenuImg%

    if (ErrorLevel = 0) {
        if (serverListChanged) {
            ToolTip, Non full server detected! Menuing, % A_ScreenWidth // 28, % A_ScreenHeight // 2
            if (manuallyHoldF == False) { 
                send, {f Up}
                sleep, 150
                send, {f Up}
                sleep, 150
                send, {f Down}
                sleep, 150
                send, {f Down}
                Sleep, 300
            }
            MouseMove, FoundX + (ImgWidth // 2), FoundY + (ImgHeight // 2)
            Sleep, 150
            send, {click}
            MouseMove, FoundX + 5, FoundY
            Sleep, 150
            send, {click}
            Sleep, 150
        } else {
            checkList()
        }
    } else {
        ToolTip, Account in Menu running anti-AFK, % A_ScreenWidth // 28, % A_ScreenHeight // 2
        Sleep, 300
        antiAFK()
    }
}


ToggleLoop() {
    global LoopFlag
    LoopFlag := !LoopFlag
    if (LoopFlag) {
        SetTimer, UpdateTooltip, Off
        TabToRobloxWindows()
    } else {
        SetTimer, UpdateTooltip, On
    }
}

TabToRobloxWindows() {
    global LoopFlag, robloxWindows, windowArray, tooltipText, activeWindow
    
    while (LoopFlag) {
        WinGet, windows, List, ahk_class WINDOWSCLIENT
        robloxWindows := windows
        ToolTip, %robloxWindows% Active windows, % A_ScreenWidth // 28, % A_ScreenHeight // 1.9, 6

        Loop, % windows
        {
            window := windows%A_Index%
            WinActivate, ahk_id %window%
            WinWaitActive, ahk_id %window%, , 5

            if (WinActive("ahk_id " window)) {
                currentWindowIndex := -1
                Loop, % windowArray.MaxIndex() 
                {
                    if (window = windowArray[A_Index]) {
                        currentWindowIndex := A_Index  
                        activeWindow := A_Index
                        ; MsgBox, %activeWindow%
                        break
                    }
                }

                if (tooltipText != currentWindowIndex) {
                    tooltipText := currentWindowIndex
                    ToolTip, %tooltipText%, % A_ScreenWidth // 100, % A_ScreenHeight * 0.1, 10
                    ;MsgBox, %activeWindow%
                }
                
                ToolTip, Tabbing Roblox Windows, A_ScreenWidth // 28, % A_ScreenHeight // 2

                getWindowSettings()
                Sleep, 500
                checkSpawned()
            }
        }
    }
}


F2::
getGlobalSettings()
ToggleLoop()
return

F3::Reload
return

F4::
settingsFolder := A_ScriptDir . "\Settings"

Loop, %settingsFolder%\*.txt
{
    if (A_LoopFileName != "Global.txt")
    {
        FileDelete, %A_LoopFilePath%
    }
}
ExitApp
Return


/*
------------[Credits]------------

Script made by .dont.blink.

dont dm me for issues, i made this
public because i dont care abt
rogue anymore.


*/
