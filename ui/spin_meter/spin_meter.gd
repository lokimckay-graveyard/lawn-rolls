extends Control

@export var speed = 1.0

var value = 0
var indicator
var direction = 1
var meterSize = 1200

func _ready():
	indicator = $CenterContainer/Meter/Container/Scale/Indicator
	setActive(false)

func _process(delta):
	if(!Game.playing || !visible): return
	var pos = indicator.position.x
	
	if (pos >= meterSize - indicator.size.x): direction = -1
	elif (pos <= 0): direction = 1
	
	var newPos = pos + ((speed * meterSize) * delta * direction)
	value = (clamp(newPos / meterSize, 0, 1) - 0.5) * 2
	indicator.position.x = newPos

func setActive(newValue):
	visible = newValue
	if(!newValue):
		value = 0
		indicator.position.x = (meterSize / 2) - (indicator.size.x / 2)
