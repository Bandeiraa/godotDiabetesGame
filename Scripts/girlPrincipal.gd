extends Control

onready var principalSceneAnimator = get_node("Animator")
var _changeScene

func _ready():
	pass

func onGearPressed():
	principalSceneAnimator.play("gearAnimation")
	yield(get_tree().create_timer(0.5), "timeout")
	$Menu.set_visible(true)

func onQuizButtonPressed():
	_changeScene = get_tree().change_scene("res://Scenes/girlScenes/girlQuizScreen.tscn")

func onBackToSceneButtonPressed():
	$Menu.set_visible(false)
