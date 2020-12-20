extends Control

var _changeScene

func _ready():
	InitialSong.play()
	ProjectManager.quizResult.hasInternet = false
	ProjectManager.save()
	
func onChangeScene():
	BlinkAnimation.canPlay()
	yield(get_tree().create_timer(0.7), "timeout")
	_changeScene = get_tree().change_scene("res://Scenes/InitialScenes/Initial/CharacterSelectScreen.tscn")
