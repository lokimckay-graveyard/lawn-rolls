extends RigidDynamicBody3D

@export var pushStrength = 1
var justCollided = false
var wasSleeping = false
var hasBounced = false
var hasFinished = false

signal finished_rolling(result)

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

# Returns which side of die is currently facing upwards
func getCurrentValue():
	if transform.basis.y.y > 0.99: return 6
	elif transform.basis.y.y < -0.99: return 1
	elif transform.basis.x.y > 0.99: return 3
	elif transform.basis.x.y < -0.99: return 4
	elif transform.basis.z.y > 0.99: return 5
	elif transform.basis.z.y < -0.99: return 2
	return 0

func onSleepingStateChanged():
	if(sleeping): wasSleeping = true
	if(!hasFinished):
		emit_signal("finished_rolling", getCurrentValue())
		hasFinished = true

func setOwner(contenderIndex):
	set_meta("owner", contenderIndex)
	$Mesh.get_active_material(0).albedo_color = Colours.contenderColours[contenderIndex]
