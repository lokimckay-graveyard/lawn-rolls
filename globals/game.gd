extends Node

var victoryThreshold = 20

var playing = false
var isGameover = false
var turnCount = -1
var playersAndAI = []
var currentContender
var currentContenderType

signal new_match(playersAndAI)
signal new_turn(turnCount, currentContender)
signal new_result(result, player)
signal scores_change(playersAndAI)
signal gameover(winners, playersAndAI)

func _ready(): process_mode = Node.PROCESS_MODE_ALWAYS

func _process(_delta):
	if Input.is_action_just_pressed("pause"): togglePause()

func newMatch(numPlayers, numAI):
	reset()
	removeDecorations()
	addContenders(numPlayers, "player")
	addContenders(numAI, "AI")
	hydrateContenders()
	calculateScores()
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
	calculateScores()
	await get_tree().create_timer(1).timeout
	if(playing): newTurn()

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
	if(isGameover): return
	var newValue = !UI.pauseMenuVisible()
	get_tree().paused = newValue
	playing = !newValue
	UI.setPauseMenuVisible(newValue)

func calculateScores():
	for index in playersAndAI.size():
		var contender = playersAndAI[index]
		contender.score = 0
	
	for die in Ref.dice().get_children():
		var contenderIndex = die.get_meta("owner")
		var contender = playersAndAI[contenderIndex]
		contender.score += die.getCurrentValue()
	
	print("SIGNAL: scores_change", playersAndAI)
	emit_signal("scores_change", playersAndAI)
	checkVictory()

func checkVictory():
	var winners = []
	for index in playersAndAI.size():
		var contender = playersAndAI[index]
		if (contender.score >= victoryThreshold): winners.append(contender)
	if (winners.size() > 0): announceVictory(winners)

func announceVictory(winners):
	playing = false
	isGameover = true
	print("SIGNAL: gameover", winners, playersAndAI)
	emit_signal("gameover", winners, playersAndAI)

func removeDecorations(): Ref.level().remove_child(Ref.decorative())

func reset():
	playing = false
	turnCount = -1
	playersAndAI = []
	currentContender = null
	isGameover = false

func restart():
	get_tree().paused = false
	get_tree().reload_current_scene()

func quit():
	get_tree().paused = false
	get_tree().quit()
