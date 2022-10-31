; SingleInstance restarts the script every time you run it with no dialog.
; Max Threads Per Hotkey seems to do something.
#SingleInstance, Force
#MaxThreadsPerHotkey 2
; InputBox, VarTime, Enter time, Type the time in seconds
IntervalTime := 9*1000*60 ; 9 mins (1/2 afk timer - 1 for redundancy)
; toggle := false
Return

F1::
  toggle := !toggle
	if (!toggle) {
		Reload
	}
  While (toggle) {
		if WinExist("Roblox") {
    	WinActivate ; Use the window found by WinExist.
			sleep 200

			; Reconnect
			WinGetPos, winX, winY, winWidth, winHeight, A
			X := winWidth * 0.525
			Y := winHeight * 0.548
			Click %X% %Y% 2 ; Click, 1350 780 2
			sleep 600

			; Break AFK with jump
			send {space down}
			sleep 100
			send {space up}
			sleep 500

			; Buy anything infront of you
			send {e down}
			sleep 100
			send {e up}
			sleep 3000

			; close egg showcase
			send {e down}
			sleep 100
			send {e up}
		} else {
			Return
		}
		sleep %IntervalTime%
	}
Return