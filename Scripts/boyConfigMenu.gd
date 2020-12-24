extends Control

var _changeScene
signal canHide
onready var checkedButton = get_node("Container/CheckSoundButton/Checked")
var key = true

func onAboutButtonPressed():
	$ContainerAux.show()
	$Container.hide()
	
func onBackToCharSelect():
	BlinkAnimation.canPlay()
	yield(get_tree().create_timer(0.7), "timeout")
	_changeScene = get_tree().change_scene("res://Scenes/InitialScenes/Initial/CharacterSelectScreen.tscn")

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
		
func onBackButtonPressed():
	$ContainerAux.hide()
	$Container.show()
