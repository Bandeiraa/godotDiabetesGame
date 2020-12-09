extends Control

onready var menuAnimation = get_node("Animator")
var _changeSceneTo

func _ready():
	menuAnimation.play("BlinkANimation")

func onBoyButtonPressed():
	menuAnimation.play("BlinkScreen")
	yield(get_tree().create_timer(0.7), "timeout")
	_changeSceneTo = get_tree().change_scene("res://Scenes/boyScenes/boyPrincipal.tscn")

func onGirlButtonPressed():
	menuAnimation.play("BlinkScreen")
	yield(get_tree().create_timer(0.7), "timeout")
	_changeSceneTo = get_tree().change_scene("res://Scenes/girlScenes/girlPrincipal.tscn")
