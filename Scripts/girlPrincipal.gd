extends Control

onready var principalSceneAnimator = get_node("Animator")
var _changeScene
var menuScene

func _ready():
	menuScene = preload("res://Scenes/girlScenes/girlConfigMenu.tscn")

func onGearPressed():
	principalSceneAnimator.play("gearAnimation")
	yield(get_tree().create_timer(0.5), "timeout")
	$menuSpawn.show()
	var menuInstanced = menuScene.instance()
	$menuSpawn.add_child(menuInstanced)
	menuInstanced.connect("canHide", self, "canHideMenu")

func onQuizButtonPressed():
	principalSceneAnimator.play("blinkScreen")
	yield(get_tree().create_timer(0.7), "timeout")
	_changeScene = get_tree().change_scene("res://Scenes/girlScenes/girlQuizScreen.tscn")

func onBackToSceneButtonPressed():
	$Menu.set_visible(false)

func onPlayButtonPressed():
	InitialSong.stop()
	MainGameSong.play()
	ProjectManager.quizResult.totalScore = 0
	ProjectManager.quizResult.glucoseAmount = "70"
	ProjectManager.quizResult.candiesCount = 0
	ProjectManager.quizResult.bonus = 0
	ProjectManager.save()
	print(ProjectManager.quizResult.glucoseAmount)
	principalSceneAnimator.play("blinkScreen")
	yield(get_tree().create_timer(0.7), "timeout")
	_changeScene = get_tree().change_scene("res://Scenes/girlScenes/girlGameScene.tscn")
	
func canHideMenu():
	$menuSpawn.hide()

func onRankingButtonPressed():
	ProjectManager.loadData()
	if ProjectManager.quizResult.hasInternet == true:
		_changeScene = get_tree().change_scene("res://addons/silent_wolf/Scores/Leaderboard.tscn")
