extends Path3D

@export var bendiness = 1.0

func bend(amount):
	var amt = snapped(clamp(amount, -1, 1), 0.25)
	var bendStart = 5 * bendiness
	var bendEnd = 2.5 * bendiness
	curve.set_point_out(0, Vector3(amt * bendStart, 0, 5))
	curve.set_point_in(1, Vector3(amt * bendEnd, 0, -5))
	
	var head = get_parent().get_node("Aim/Indicator/Head")
	head.rotation.y = deg2rad(45 * amt)
