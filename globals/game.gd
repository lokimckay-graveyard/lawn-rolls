extends Node

var playing = false
signal new_match(players, ai)

func _process(_delta):
	if Input.is_action_just_pressed("pause"): togglePause()

func newMatch(players, ai):
	print("SIGNAL: new_match")
	emit_signal("new_match", players, ai)
	playing = true

func togglePause():
	var newValue = !UI.pauseMenuVisible()
	playing = !newValue
	UI.setPauseMenuVisible(newValue)

func restart(): get_tree().reload_current_scene()
func quit(): get_tree().quit()

