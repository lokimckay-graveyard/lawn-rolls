extends Node3D

@export var pushForce = 30
@export var spinForce = 30

var dice = preload("res://die/die.tscn")

var state = "aiming" # aiming / powering
var aimedSpawn
var aimedBasis
var aimedDir
var aimedSpin

func _ready():
	Game.connect("new_match", onNewMatch)
	switchState("disabled")

func _process(_delta):
	if(!Game.playing): return
	if(state == "aiming"): aim()
	elif(state == "powering"): power()

func onNewMatch(_players, _ai): switchState("aiming")

func aim():
	$Aim.rotation.y = Ref.mainCamPlane()[2]
	$Path3D.bend($SpinMeter.value)
	if (Input.is_action_just_pressed("shoot")): lockAim()

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
	if (Input.is_action_just_pressed("shoot")): shoot()

func shoot():
	var newDie = dice.instantiate()
	newDie.position = aimedSpawn
	newDie.basis = aimedBasis
	newDie.apply_impulse(aimedDir * pushForce)
	newDie.angular_velocity = aimedSpin * spinForce
	Ref.level().add_child(newDie)
	switchState("disabled")

func switchState(newState):
	$SpinMeter.setActive(newState == "aiming")
	visible = newState != "disabled"
	state = newState
