extends Control

onready var animation = get_node("blinkAnimator")
var _changeScene

func _ready():
	InitialSong.play()
	ProjectManager.quizResult.hasInternet = false
	ProjectManager.save()
	
func onChangeScene():
	animation.play("blinkScreen")
	yield(get_tree().create_timer(0.7), "timeout")
	_changeScene = get_tree().change_scene("res://Scenes/InitialScenes/Initial/CharacterSelectScreen.tscn")
