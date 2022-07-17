extends Node3D

@export var indicatorLength = 15
@export var offset = 5

func setFill(amount):
	var amt = 1 - amount
	$Body.material.set_shader_param("Position", (amt * indicatorLength) - offset)
	$Body.material.set_shader_param("Power", amt)
