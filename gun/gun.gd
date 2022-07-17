extends Node3D

@export var minPushForce = 20
@export var maxPushForce = 40
@export var spinForce = 30

var dice = preload("res://die/die.tscn")

var state = "aiming" # disabled / aiming / powering
var playerInControl
var aimedSpawn
var aimedBasis
var aimedDir
var aimedSpin

func _ready():
	Game.connect("new_match", onNewMatch)
	Game.connect("new_turn", onNewTurn)
	switchState("disabled")

func _process(_delta):
	if(!Game.playing): return
	if(state == "aiming"): aim()
	elif(state == "powering"): power()

func aim():
	$Aim.rotation.y = Ref.mainCamPlane()[2]
	$Path3D.bend($SpinMeter.value)
	if (playerInControl && Input.is_action_just_pressed("shoot")): lockAim()

func lockAim():
	aimedSpawn = $Aim/SpawnPoint.global_transform.origin
	aimedBasis = $Aim/SpawnPoint.global_transform.basis
	aimedDir = Ref.aimDir()
	
	var spinValue = snapped($SpinMeter.value, 1)
	var spinVec = Vector3(-1, 0, 0.1 * spinValue) # X = forward/backward, Y = bottlecap, Z = barrel roll
	var rotatedVec = spinVec.rotated(Vector3.UP, Ref.aimDeg())
	aimedSpin = rotatedVec
	switchState("powering")

func power():
	$Aim/Indicator.setFill($PowerMeter.value)
	if (playerInControl && Input.is_action_just_pressed("shoot")): shoot($PowerMeter.value)

func shoot(_power):
	var pushForce = lerp(minPushForce, maxPushForce, _power)
	var newDie = dice.instantiate()
	newDie.position = aimedSpawn
	newDie.basis = aimedBasis
	newDie.apply_impulse(aimedDir * pushForce)
	newDie.angular_velocity = aimedSpin * spinForce
	newDie.connect("finished_rolling", onDieStopped)
	newDie.setOwner(Game.currentContender.index)
	Ref.dice().add_child(newDie)
	switchState("disabled")

func switchState(newState):
	
	$SpinMeter.setActive(newState == "aiming")
	$PowerMeter.setActive(newState == "powering")
	visible = newState != "disabled"
	if (newState == "aiming"): $Aim.rotation.y = Ref.mainCamPlane()[2]
	if (newState == "disabled"):
		$Path3D.bend(0)
		$Aim/Indicator.setFill(0)
	state = newState

func onDieStopped(result):
	Game.turnResult(result)

func onNewMatch(_playersAndAI): switchState("aiming")
func onNewTurn(_turnCount, player):
	switchState("aiming")
	playerInControl = Game.currentContenderType == "player"
	if(player.type == "AI" && Game.playing): takeAITurn()

func takeAITurn():
	print("AI is aiming...")
	await get_tree().create_timer(randf_range(0.5, 1), false).timeout
	lockAim()
	print("AI is powering...")
	await get_tree().create_timer(randf_range(0.5, 1), false).timeout
	shoot($PowerMeter.value)
