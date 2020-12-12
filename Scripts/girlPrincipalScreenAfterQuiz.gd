extends Control

onready var Animator = get_node("Animator")
var _changeScene
var menuScene

func _ready():
	ProjectManager.loadData()
	$totalPoints.text = ProjectManager.quizResult.totalPoints
	$correctAnswers.text = str(ProjectManager.quizResult.correctAnswers)
	$wrongAnswers.text = str(ProjectManager.quizResult.wrongAnswers)
	menuScene = preload("res://Scenes/girlScenes/girlConfigMenu.tscn")

func onGearPressed():
	Animator.play("gearAnimation")
	yield(get_tree().create_timer(0.5), "timeout")
	$menuSpawn.show()
	var menuInstanced = menuScene.instance()
	$menuSpawn.add_child(menuInstanced)
	menuInstanced.connect("canHide", self, "canHideMenu")

func onBackButtonPressed():
	$Menu.set_visible(false)

func onPlayButtonPressed():
	InitialSong.stop()
	MainGameSong.play()
	ProjectManager.quizResult.totalScore = 0
	ProjectManager.quizResult.glucoseAmount = "70"
	ProjectManager.quizResult.candiesCount = 0
	ProjectManager.save()
	Animator.play("blinkAnimation")
	yield(get_tree().create_timer(0.7), "timeout")
	_changeScene = get_tree().change_scene("res://Scenes/girlScenes/girlGameScene.tscn")
	
func canHideMenu():
	$menuSpawn.hide()
