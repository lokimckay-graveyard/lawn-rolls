extends Control

var entry = preload("res://ui/scores/entry.tscn")

func _ready():
	hide()
	Game.connect("new_match", onNewMatch)
	Game.connect("gameover", onGameOver)
	Game.connect("scores_change", onScoreChange)

func removeAllEntries():
	for child in $VBox/ScoreList.get_children(): child.queue_free()

func addEntry(contender, contenderIndex):
	var newEntry = entry.instantiate()
	newEntry.text = "%s %s: %s" % [contender.type.to_upper(), contenderIndex + 1, contender.score]
	newEntry.add_theme_color_override("font_color", contender.colour)
	$VBox/ScoreList.add_child(newEntry)

func onScoreChange(playersAndAI):
	removeAllEntries()
	for index in playersAndAI.size():
		var contender = playersAndAI[index]
		addEntry(contender, index)

func onNewMatch(_playersAndAI): show()
func onGameOver(_winners, _playersAndAI): hide()
