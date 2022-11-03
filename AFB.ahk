; AHK v2
#SingleInstance Force
SetTitleMatchMode 3

/*
	constants
*/
ONE_MIN			 := 60 * 1000
THREE_MINS	 := 3 * ONE_MIN
FIVE_MINS 	 := 5 * ONE_MIN
FIFTEEN_MINS := 15 * ONE_MIN

DATA_DIR 									 := A_WorkingDir . "\data"
RECONNECT_BUTTON_IMG 			 := DATA_DIR . "\reconnect-button.png"
RECONNECT_TEXT_IMG 				 := DATA_DIR . "\reconnect-text.png"
RECONNECT_IMG_SEARCH_ARRAY := [RECONNECT_BUTTON_IMG, RECONNECT_TEXT_IMG]

DirCreate(DATA_DIR)
FileInstall("data\reconnect-button.png", RECONNECT_BUTTON_IMG, 1)
FileInstall("data\reconnect-text.png", RECONNECT_TEXT_IMG, 1)

/*
	globals
*/
IsRunning := false
SetTrayTip("Script is ready for input.`n`nAnti-kick: Disabled")

#MaxThreadsPerHotkey 2
F1:: {
	global IsRunning := !IsRunning
	if (IsRunning) {
		SetTrayTip("Anti-kick: Enabled")
	} else {
		Reload()
	}

	while (IsRunning) {
		lastID := WinExist("A")
		robloxID := WinExist("Roblox")
		if (robloxID) {
			; BEGIN WORK - any automation must be done between the BlockInputs
			BlockInput(True)

			WinActivate(robloxID)
			if (WinWaitActive(robloxID, , 10)) {
				WinGetPos(&winX, &winY, &winWidth, &winHeight, robloxID)
				Reconnect(winWidth, winHeight)
				BreakAFK()
			}

			BlockInput(False)
			; END OF WORK

			if (lastID && lastID != robloxID) {
				WinActivate(lastID)
				WinWaitActive(lastID, , 1)
			}

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
	sleep(300)
	; TODO allow action to be defined by user upon startup and/or config
	send("{Space down}")
	sleep(50)
	send("{Space up}")
	sleep(500)
	send("{Space down}")
	sleep(50)
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
	} catch as err {
		MsgBox("Something went wrong when trying to check for reconnect button:`n" err.Message)
		Reload()
	}
	return 0
}

/*
	Returns a random time between 3mins and 15mins
		(avg 9mins: 1/2 AFK timer - 1 (this is for redundancy))
*/
GetIntervalMins() {
	randomMins := Random(THREE_MINS, FIFTEEN_MINS)
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
	Sleep(350)
	Click(clickX, clickY)
}

SetTrayTip(str, title := "AwayFromBlox") {
	TrayTip(str, title)
}