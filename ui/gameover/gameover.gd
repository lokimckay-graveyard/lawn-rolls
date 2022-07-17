extends Control

var winnersList
var scoresList

var winnerScene = preload("res://ui/gameover/winner.tscn")
var scoreScene = preload("res://ui/gameover/score.tscn")

func _ready():
	hide()
	winnersList = $Margin/CenterContainer/VBoxContainer/VBoxContainer/Winners
	scoresList = $Margin/CenterContainer/VBoxContainer/Scores
	Game.connect("gameover", onGameOver)

func onGameOver(_winners, playersAndAI):
	UI.setCursorVisible(true)
	removeAllEntries()
	for contenderIndex in playersAndAI.size():
		var contender = playersAndAI[contenderIndex]
		if(contender.score >= Game.victoryThreshold): addWinner(contender, contenderIndex)
		addScore(contender, contenderIndex)
	show()

func removeAllEntries():
	for child in winnersList.get_children(): child.queue_free()
	for child in scoresList.get_children(): child.queue_free()

func addWinner(contender, contenderIndex):
	var newWinner = winnerScene.instantiate()
	newWinner.text = "%s %s" % [contender.type.to_upper(), contenderIndex + 1]
	newWinner.add_theme_color_override("font_color", contender.colour)
	winnersList.add_child(newWinner)

func addScore(contender, contenderIndex):
	var newScore = scoreScene.instantiate()
	newScore.text = "%s %s: %s" % [contender.type.to_upper(), contenderIndex + 1, contender.score]
	newScore.add_theme_color_override("font_color", contender.colour)
	scoresList.add_child(newScore)

func onRestartPressed(): Game.restart()
func onQuitPressed(): Game.quit()
