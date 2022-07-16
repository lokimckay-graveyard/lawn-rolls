# UI Manager (autoloaded)
extends Node

func _process(_delta):
	if Input.is_action_just_pressed("pause"): togglePause()

func showCursor(): Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
func hideCursor(): Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
func setCamOrbit(newValue): Ref.mainCam().setOrbit(newValue)

func togglePause():
	if (pauseMenuVisible()): hidePauseMenu()
	else: showPauseMenu()

func showPauseMenu():
	if (mainMenuVisible()): return
	Ref.pauseMenu().show()
	setCamOrbit(false)
	showCursor()

func hidePauseMenu():
	Ref.pauseMenu().hide()
	setCamOrbit(true)
	hideCursor()

func showMainMenu():
	Ref.mainMenu().show()
	setCamOrbit(false)
	showCursor()
	
	Ref.pauseMenu().hide()

func hideMainMenu():
	Ref.mainMenu().hide()
	setCamOrbit(true)
	hideCursor()

func pauseMenuVisible(): return Ref.pauseMenu().visible
func mainMenuVisible(): return  Ref.mainMenu().visible
