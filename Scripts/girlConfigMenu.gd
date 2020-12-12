extends Control

var _changeScene
signal canHide
onready var blinkAnim = get_node("blinkAnimation")

func onAboutButtonPressed():
	pass
	
func onBackToCharSelect():
	blinkAnim.play("blinkAnimation")
	yield(get_tree().create_timer(0.7), "timeout")
	_changeScene = get_tree().change_scene("res://Scenes/InitialScreen.tscn")

func onCancelButtonPressed():
	emit_signal("canHide")
