extends Control

onready var principalSceneAnimator = get_node("Animator")
var _changeScene

func onGearPressed():
	principalSceneAnimator.play("gearAnimation")
	yield(get_tree().create_timer(0.5), "timeout")
	$Menu.set_visible(true)
	
func onBackToSceneButtonPressed():
	$Menu.set_visible(false)

func onQuizButtonPressed():
	_changeScene = get_tree().change_scene("res://Scenes/boyScenes/boyQuizScreen.tscn")
