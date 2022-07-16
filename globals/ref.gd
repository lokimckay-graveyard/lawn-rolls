# Reference manager (autoloaded)
extends Node

func mainMenu():
	return get_node("/root/Main/Menu")

func pauseMenu():
	return get_node("/root/Main/Pause")

func gun():
	return get_node("/root/Main/Gun")

func aim():
	return get_node("/root/Main/Gun/Aim")

func aimDir():
	return -aim().global_transform.basis.z

func aimDeg():
	return gun().basis.get_euler().y

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

func level():
	return get_node("/root/Main/Level")

func ground():
	return get_node("/root/Main/Level/Ground")
