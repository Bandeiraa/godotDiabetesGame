extends Control

var _changeScene
onready var exerciseAnimator = get_node("exerciseAnimator")
onready var exercisePopup = get_node("exercisePopup2")

func _ready():
	ProjectManager.loadData()
	print(ProjectManager.quizResult.glucoseAmount)
	exerciseAnimator.play("exerciseAnimation")
	
func onBackToGameButtonPressed():
	PopupButton.play()
	exerciseAnimator.play("fadeAnimation")
	yield(get_tree().create_timer(0.7), "timeout")
	_changeScene = get_tree().change_scene("res://Scenes/EndScenes/Game/Girl/GameScene.tscn")
	
func onAnimationFinished():
	exercisePopup.set_visible(true)
	pass
