#SingleInstance Force

IsRunning := false

#MaxThreadsPerHotkey 2
F1:: {
  global IsRunning := !IsRunning
  While (IsRunning) {
		if WinExist("Roblox") {
    	WinActivate ; defaults to WinExist
			WinGetPos(&winX, &winY, &winWidth, &winHeight) ; defaults to WinExist

			; Reconnect
			Reconnect(winWidth, winHeight)

			; Break AFK
			; TODO allow action to be defined by user upon startup and/or config
			send("{Space down}")
			sleep(100)
			send("{Space up}")
		} else {
			Return
		}
		antiKickInterval := GetIntervalMins()
		sleep antiKickInterval
	}
}

; Attemps to reconnect the user if the reconnection box is detected
Reconnect(winWidth, winHeight) {
	try {
		searchImage := "plugins/roblox/reconnect-button.png"
		if (ImageSearch(&foundX, &foundY, 0, 0, winWidth, winHeight, searchImage)) {
			ClickImageMidPoint(searchImage, foundX, foundY)
			return 1
		}

		; try with smaller image, this seems to be less reliable
		searchImage := "plugins/roblox/reconnect-text.png"
		if (ImageSearch(&foundX, &foundY, 0, 0, winWidth, winHeight, searchImage)) {
			ClickImageMidPoint(searchImage, foundX, foundY)
			return 1
		}
	} catch as exc {
		MsgBox "Something went wrong when trying to check for reconnect button:`n" exc.Message
		Reload
	}
	return 0
}

; Returns a random time between 3mins and 15mins
;  (avg 9mins: 1/2 AFK timer - 1 (this is for redundancy))
GetIntervalMins() {
		threeMins := 3*1000*60
		sixteenMins := 15*1000*60
    antiKickInterval := Random(threeMins, sixteenMins)
    return antiKickInterval
}

; Returns the middel of coordinates of an image
;  Alternative to loading GDI+ lib: https://www.autohotkey.com/boards/viewtopic.php?p=445556#p445556
GetImageMidPoint(file) {
	imgGui := Gui()
	img := imgGui.Add("Picture",, file)
	imgGui.Show("Hide")
	ControlGetPos(,, &w, &h, img.hwnd)
	imgGui.Destroy()
	return [w/2, h/2]
}

; Clicks the middle of an image with an offset
ClickImageMidPoint(imageFile, xOffset, yOffset) {
	imageMidPoint := GetImageMidPoint(imageFile)
	clickX := imageMidPoint[1] + xOffset
	clickY := imageMidPoint[2] + yOffset

	; ! Clicks seems to be flakey, this is why using two Click() instead of the 3rd parameter
	Click(clickX, clickY)
	sleep(350)
	Click(clickX, clickY)
}