extends Node

func newMatch(_players, _ai):
	print("New match started")

func restart():
	get_tree().reload_current_scene()

func quit():
	get_tree().quit()
