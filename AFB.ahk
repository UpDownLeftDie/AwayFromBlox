#SingleInstance Force

/*
	constants
*/
ONE_MIN			 := 1000 * 60
THREE_MINS	 := 3 * ONE_MIN
FIVE_MINS 	 := 5 * ONE_MIN
SIXTEEN_MINS := 15 * ONE_MIN
DATA_DIR := A_WorkingDir . "\data"
RECONNECT_BUTTON_IMG := DATA_DIR . "\reconnect-button.png"
RECONNECT_TEXT_IMG := DATA_DIR . "\reconnect-text.png"
RECONNECT_IMG_SEARCH_ARRAY := [RECONNECT_BUTTON_IMG, RECONNECT_TEXT_IMG]

DirCreate(DATA_DIR)
FileInstall("data\reconnect-button.png", RECONNECT_BUTTON_IMG, 1)
FileInstall("data\reconnect-text.png", RECONNECT_TEXT_IMG, 1)

/*
	globals
*/
IsRunning := false
TrayTip("Script is ready for input. AntiKick is disabled.", "AwayFromBlox")

#MaxThreadsPerHotkey 2
F1:: {
	global IsRunning := !IsRunning
	If (IsRunning) {
		TrayTip("AntiKick is enabled.", "AwayFromBlox")
	} Else {
		Reload()
	}

	While (IsRunning) {
		lastID := WinGetID("A")
		robloxID := WinExist("Roblox")
		if (robloxID) {
			; BEGIN WORK
			BlockInput(True)

			WinActivate(robloxID)
			WinGetPos(&winX, &winY, &winWidth, &winHeight, robloxID)

			Reconnect(winWidth, winHeight)

			BreakAFK()

			WinActivate(lastID)
			BlockInput(False)
			; END OF WORK

			antiKickInterval := GetIntervalMins()
			sleep(antiKickInterval)
		} else {
			sleep(FIVE_MINS)
		}
	}
}

/*
	Core logic for "breaking" afk idle timer
*/
BreakAFK() {
	; TODO allow action to be defined by user upon startup and/or config
	send("{Space down}")
	sleep(100)
	send("{Space up}")
}

/*
	Attempts to reconnect the user if the reconnection box is detected
*/
Reconnect(winWidth, winHeight) {
	try {
		for (searchImage in RECONNECT_IMG_SEARCH_ARRAY) {
			if (ImageSearch(&foundX, &foundY, 0, 0, winWidth, winHeight, searchImage)) {
				ClickImageMidPoint(searchImage, foundX, foundY)
				return 1
			}
		}
	} catch as exc {
		MsgBox "Something went wrong when trying to check for reconnect button:`n" exc.Message
		Reload
	}
	return 0
}

/*
	Returns a random time between 3mins and 15mins
		(avg 9mins: 1/2 AFK timer - 1 (this is for redundancy))
*/
GetIntervalMins() {
	randomMins := Random(THREE_MINS, SIXTEEN_MINS)
	return randomMins
}

/*
	Returns the middle of coordinates of an image
		Alternative to loading GDI+ lib: https://www.autohotkey.com/boards/viewtopic.php?p=445556#p445556
*/
GetImageMidPoint(file) {
	imgGui := Gui()
	img 	 := imgGui.Add("Picture",, file)
	imgGui.Show("Hide")
	ControlGetPos(,, &w, &h, img.hwnd)
	imgGui.Destroy()
	return [w/2, h/2]
}

/*
	Clicks the middle of an image with an offset
*/
ClickImageMidPoint(imageFile, xOffset, yOffset){
	imageMidPoint := GetImageMidPoint(imageFile)
	clickX 				:= imageMidPoint[1] + xOffset
	clickY 				:= imageMidPoint[2] + yOffset

	; ! Clicks seems to be flakey, this is why using two Click() instead of the 3rd parameter
	Click(clickX, clickY)
	sleep(350)
	Click(clickX, clickY)
}