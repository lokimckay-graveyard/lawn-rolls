extends Control

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	hide()
func onRestartPressed(): Game.restart()
func onQuitPressed(): Game.quit()
