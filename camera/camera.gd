extends Node3D

@export var active = false
@export var sensitivity = 0.1
@export var minPitch = -90
@export var maxPitch = -20

var yaw
var pitch

func _ready():
	yaw = rad2deg($Pivot.rotation.y)
	pitch = rad2deg($Pivot.rotation.x)

func _input(event):
	if(!active): return
	if event is InputEventMouseMotion:
		yaw += -1 * event.relative.x * sensitivity
		pitch += event.relative.y * sensitivity
		pitch = clamp(pitch, minPitch, maxPitch)

func _physics_process(_delta):
	if(!active): return
	$Pivot.rotation.y = deg2rad(yaw)
	$Pivot.rotation.x = deg2rad(pitch)

func setOrbit(newValue): active = newValue
