# Reference manager (autoloaded)
extends Node

func mainMenu():
	return get_node("/root/Main/Menu")

func pauseMenu():
	return get_node("/root/Main/Pause")

func mainCam(): 
	return get_node("/root/Main/Camera")

func mainCamPivot():
	return get_node("/root/Main/Camera/Pivot")

func mainCamPlane():
	var camPivot = get_node("/root/Main/Camera/Pivot")
	var camForward = camPivot.basis.z
	var camRight = camPivot.basis.x
	var camYRot = camPivot.basis.get_euler().y
	camForward.y = 0
	camRight.y = 0
	return [camForward, camRight, camYRot]

