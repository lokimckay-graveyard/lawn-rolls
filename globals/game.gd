extends Node

var playing = false
var turnCount = -1
var playersAndAI = []
var currentContender
var currentContenderType

signal new_match(playersAndAI)
signal new_turn(turnCount, currentContender)
signal new_result(result, player)

func _process(_delta):
	if Input.is_action_just_pressed("pause"): togglePause()

func newMatch(numPlayers, numAI):
	reset()
	addContenders(numPlayers, "player")
	addContenders(numAI, "AI")
	hydrateContenders()
	print("SIGNAL: new_match", playersAndAI)
	emit_signal("new_match", playersAndAI)
	playing = true
	newTurn()

func newTurn():
	turnCount += 1
	setCurrentPlayer()
	print("SIGNAL: new_turn %s %s" % [turnCount, currentContender])
	emit_signal("new_turn", turnCount, currentContender)

func turnResult(result):
	print("SIGNAL: new_result %s %s" % [result, currentContender])
	emit_signal("new_result", result, currentContender)
	await get_tree().create_timer(1).timeout
	newTurn()

func setCurrentPlayer():
	currentContender = playersAndAI[turnCount % playersAndAI.size()]
	currentContenderType = currentContender.type

func addContenders(count, type):
	for i in count.to_int(): playersAndAI.append({ "type": type })

func hydrateContenders():
	for index in playersAndAI.size():
		var contender = playersAndAI[index]
		var colourIndex = index % Colours.contenderColours.size()
		var newColour = Colours.contenderColours[colourIndex]
		contender.colour = newColour
		contender.index = index

func togglePause():
	var newValue = !UI.pauseMenuVisible()
	playing = !newValue
	UI.setPauseMenuVisible(newValue)

func reset():
	playing = false
	turnCount = -1
	playersAndAI = []
	currentContender = null

func restart(): get_tree().reload_current_scene()
func quit(): get_tree().quit()
