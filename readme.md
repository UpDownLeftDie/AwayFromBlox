# Away From Blox (AFB)

AutoHotkey scripts to specifically to help you when you're *Away From (Ro)Blox*

## How to use (.exe file)

1. [Download latest release](/releases/latest)
2. Double-click to run
3. Press `F1` to activate

## How to use (.ahk file)

1. **Install [AutoHotkey v2](https://www.autohotkey.com/download/ahk-v2.exe)** Beta or higher
2. [Download latest release](/releases/latest)
3. Double-click to run
4. Press `F1` to activate

## TODO

* Fix toggling
  * Probably need to replace `sleep` with a [timer](https://lexikos.github.io/v2/docs/commands/SetTimer.htm)
* Test clicking reconnection button on different resolutions
  * We may need to add additional sizes or DPIs for ImageSearch to work on a variety of devices
* Eventually remove custom `ahk2exe` github action, once its been updated to support AHK v2 (watch [GitHub-Action-Ahk2Exe](https://github.com/nekocodeX/GitHub-Action-Ahk2Exe) repo)
* Modularity
  * Support multiple games with unique AFK conditions and loops
* Swap back to last active window after executing anti-kick
* Startup config
  * Options to select which modules/game actions to load
  * Option for what the "AFK break action" is (default: space key)
