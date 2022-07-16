extends Node3D

@export var pushForce = 30
@export var spinForce = 20

var active = false
var dice = preload("res://die/die.tscn")

func _ready():
	Game.connect("new_match", onNewMatch)
	setActive(false)

func _process(_delta):
	if(!Game.playing): return
	rotation.y = Ref.mainCamPlane()[2]
	if (Input.is_action_just_pressed("shoot")): shoot()

func onNewMatch(_players, _ai): setActive(true)

func shoot():
	var newDie = dice.instantiate()
	newDie.position = $SpawnPoint.global_transform.origin
	newDie.basis = $SpawnPoint.global_transform.basis
	newDie.apply_impulse(Ref.aimDir() * pushForce)

	var spinVec = Vector3(-1, 0, 0)
	var rotatedVec = spinVec.rotated(Vector3.UP, Ref.aimDeg())
	newDie.angular_velocity = rotatedVec * spinForce
	Ref.level().add_child(newDie)

func setActive(newValue):
	visible = newValue
	active = newValue
