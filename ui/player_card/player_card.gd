extends Control


func _ready():
	hide()
	Game.connect("new_turn", onNewTurn)

func onNewTurn(turnCount, currentContender):
	show()
	$MarginContainer/VBoxContainer/Turn.text = "Turn %s" % turnCount
	$MarginContainer/VBoxContainer/Contender.text = "%s %s" % [currentContender.type.to_upper(), currentContender.index]
	$MarginContainer/VBoxContainer/Contender.add_theme_color_override("font_color", currentContender.colour)
