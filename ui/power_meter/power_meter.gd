extends Control

@export var speed = 1.0

var value = 0
var direction = 1

func _ready():
	setActive(false)

func _process(delta):
	if(!Game.playing || !visible): return
	
	if (value >= 1): direction = -1
	elif (value <= 0): direction = 1
	
	var newValue = value + speed * delta * direction
	value = clamp(newValue, 0, 1)

func setActive(newValue):
	visible = newValue
	if(!newValue): value = 0
