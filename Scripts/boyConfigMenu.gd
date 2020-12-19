extends Control

var _changeScene
signal canHide
onready var blinkAnim = get_node("blinkAnimation")
onready var checkedButton = get_node("panel/checkSoundButton/checked")
var key = true

func onAboutButtonPressed():
	pass
	
func onBackToCharSelect():
	blinkAnim.play("blinkAnimation")
	yield(get_tree().create_timer(0.7), "timeout")
	_changeScene = get_tree().change_scene("res://Scenes/InitialScreen.tscn")

func onCancelButtonPressed():
	emit_signal("canHide")

func onCheckButtonPressed():
	checkedButton.set_visible(false)
	InitialSong.stop()
	if checkedButton.is_visible() == false and key == true:
		key = false
	else:
		checkedButton.set_visible(true)
		InitialSong.play()
		key = true
