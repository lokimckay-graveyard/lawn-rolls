extends RigidDynamicBody3D

@export var pushStrength = 1
var justCollided = false
var wasSleeping = false
var hasBounced = false

func _physics_process(delta):
	if(linear_velocity.length() < 3 && linear_velocity != Vector3.ZERO && gravity_scale > 1): # Anti jittering on floor when almost stationary
		gravity_scale = 1

func onBodyEntered(body):
	if(justCollided): return # Debounce
	if(body.get_meta("name", "unknown") != "die"): return #Ignore all collisions except with other dice
	if(wasSleeping):
		wasSleeping = false
		return
	
	var deltaDir = (body.global_transform.origin - global_transform.origin).normalized()
	body.apply_central_impulse(deltaDir * linear_velocity.length() * pushStrength)
	justCollided = true
	await get_tree().create_timer(0.1).timeout
	justCollided = false


func onSleepingStateChanged(): if(sleeping): wasSleeping = true
