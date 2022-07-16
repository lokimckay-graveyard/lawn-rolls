extends Control

func onQuitPressed(): Game.quit()
func onPlayPressed():
	Game.newMatch(getNumPlayers(), getNumAI())
	UI.setMainMenuVisible(false)

func getNumPlayers(): return get_node("Container/Main/Form/NumPlayers/Input").get_line_edit().get_text()
func getNumAI(): return get_node("Container/Main/Form/NumAI/Input").get_line_edit().get_text()
