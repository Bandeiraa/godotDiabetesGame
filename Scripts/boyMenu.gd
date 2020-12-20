extends Control

onready var blinkAnimator = get_node("exerciseAnimator")
var _changeScene
signal canHide

func onTutorialButtonPressed():
	#get_tree().paused = false
	_changeScene = OS.shell_open("https://youtu.be/0maVvJVzRR4")
	pass
	
func onReloadButtonPressed():
	get_tree().paused = false
	blinkAnimator.play("fadeAnimation")
	yield(get_tree().create_timer(0.7), "timeout")
	_changeScene = get_tree().reload_current_scene()
	
func onBackToMenuPressed():
	get_tree().paused = false
	_changeScene = get_tree().change_scene("res://Scenes/MiddleScenes/Main/Boy/Main.tscn")
	
func onBackToGameButtonPressed():
	get_tree().paused = false
	emit_signal("canHide")
