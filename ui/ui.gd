# UI Manager (autoloaded)
extends Node

func setPauseMenuVisible(newValue):
	if (newValue && mainMenuVisible()): return
	Ref.pauseMenu().set_visible(newValue)
	setCamOrbit(!newValue)
	setCursorVisible(newValue)

func setMainMenuVisible(newValue):
	Ref.mainMenu().set_visible(newValue)
	setCamOrbit(!newValue)
	setCursorVisible(newValue)
	if (newValue && pauseMenuVisible()): setPauseMenuVisible(false)

func setCursorVisible(newValue):
	if (newValue): Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else: Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func setCamOrbit(newValue): Ref.mainCam().setOrbit(newValue)
func pauseMenuVisible(): return Ref.pauseMenu().visible
func mainMenuVisible(): return  Ref.mainMenu().visible
