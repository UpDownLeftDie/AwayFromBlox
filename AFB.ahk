#SingleInstance Force
CoordMode "Mouse", "Client"
CoordMode "Pixel", "Client"

isRunning := false

#MaxThreadsPerHotkey 2
F1:: {
  global isRunning := !isRunning
  While (isRunning) {
		if WinExist("Roblox") {
    	WinActivate ; defaults to WinExist
			WinGetPos ,, &winWidth, &winHeight ; defaults to WinExist

			; Reconnect
			Reconnect(winWidth, winHeight)

			; Break AFK with jump
			send "{Space down}"
			sleep 100
			send "{Space up}"

			; Buy anything infront of you
			send "{e}"
			sleep 3000
			send "{e}" ; close egg showcase
		} else {
			Return
		}
		antiKickInterval := GetIntervalMins()
		sleep antiKickInterval
	}
}

Reconnect(winWidth, winHeight) {
	; TESTING - hopefully clicks reconnect button at any scale

	; Logic here is that position is relative but the box is a fixed size
	;  so we find the relative offset of the reconnection box, then apply the
	;  fixed offset of the corner of the box to the button

	; Sample values:
	;  app: 2099, 1351
	;  upper left corner of reconnect box: 845, 550
	;  button location: 1070, 720
	;  delta: 230, 170

	; corner location / app size = relative offset
	; TODO: investigate using ImageSearch (for button) or even PixelSearch search
	boxX := winWidth * 0.403
	boxY := winHeight * 0.407
	; corner location + fixed button delta
	buttonX := boxX + 230
	buttonY := boxY + 170

	; test slightly in from the corner, this area is usually empty
	if (PixelGetColor(boxX + 10, boxY + 10) == "0x393B3D") {
		Click(buttonX, buttonY, 5)
	}
}

; Gets a random time between 3mins and 15mins
;  (avg 9mins: 1/2 AFK timer - 1 (this is for redundancy))
GetIntervalMins() {
		threeMins := 3*1000*60
		sixteenMins := 15*1000*60
    antiKickInterval := Random(threeMins, sixteenMins)
    return antiKickInterval
}