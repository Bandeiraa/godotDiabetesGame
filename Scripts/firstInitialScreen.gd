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
	ProjectManager.loadData()
	if ProjectManager.quizResult.hasInternet == true:
		_changeScene = get_tree().change_scene("res://Scenes/InitialScreenLogged.tscn")
	else:
		_changeScene = get_tree().change_scene("res://Scenes/InitialScreen.tscn")
