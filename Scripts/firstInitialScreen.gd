extends Control

onready var animation = get_node("blinkAnimator")
var _changeScene

func _ready():
	InitialSong.play()
	
func onChangeScene():
	animation.play("blinkScreen")
	yield(get_tree().create_timer(0.7), "timeout")
	_changeScene = get_tree().change_scene("res://Scenes/InitialScreen.tscn")
