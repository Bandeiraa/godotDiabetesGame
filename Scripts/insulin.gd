extends Control

onready var animator = get_node("exerciseAnimator")
onready var _changeScene
var storedGlucoseAmount

func _ready():
	ProjectManager.loadData()
	storedGlucoseAmount = int(ProjectManager.quizResult.glucoseAmount)
	storedGlucoseAmount = storedGlucoseAmount - 100
	ProjectManager.quizResult.glucoseAmount = str(storedGlucoseAmount)
	ProjectManager.save()
	animator.play("exxerciseAnimation")
	
func canChangeScene():
	$exercisePopup2.set_visible(true)

func onBackToGameButtonPressed():
	PopupButton.play()
	animator.play("fadeAnimation")
	yield(get_tree().create_timer(0.7), "timeout")
	_changeScene = get_tree().change_scene("res://Scenes/EndScenes/Game/Girl/GameScene.tscn")
