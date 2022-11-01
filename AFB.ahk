#SingleInstance Force

isRunning := false

#MaxThreadsPerHotkey 2
F1:: {
  global isRunning := !isRunning
  While (isRunning) {
		if WinExist("Roblox") {
    	WinActivate ; defaults to WinExist
			sleep 200

			; Reconnect
			WinGetPos ,, &winWidth, &winHeight ; defaults to WinExist
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
	;  working at 2k though
	X := winWidth * 0.509 ; 1310/2576
	Y := winHeight * 0.526 ; 740/1408
	if (PixelGetColor(X, Y) == "0xFFFFFF") {
		Click(X, Y, 2)
		sleep 600
	}
}

; Gets a random time between 3mins and 15mins
;  (avg 9mins: 1/2 AFK timer - 1 (for redundancy))
GetIntervalMins() {
		threeMins := 3*1000*60
		sixteenMins := 15*1000*60
    antiKickInterval := Random(threeMins, sixteenMins)
    return antiKickInterval
}