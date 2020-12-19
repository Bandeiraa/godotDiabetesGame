extends Control

onready var principalSceneAnimator = get_node("Animator")
var _changeScene
var menuScene
var canChangeScene = false

func _ready():
	menuScene = preload("res://Scenes/InterfaceScenes/Boy/BoyConfigMenu.tscn")
	
func onGearPressed():
	principalSceneAnimator.play("gearAnimation")
	yield(get_tree().create_timer(0.5), "timeout")
	$menuSpawn.show()
	var menuInstanced = menuScene.instance()
	$menuSpawn.add_child(menuInstanced)
	menuInstanced.connect("canHide", self, "canHideMenu")
	
func onBackToSceneButtonPressed():
	$Menu.set_visible(false)

func onQuizButtonPressed():
	principalSceneAnimator.play("blinkScreen")
	yield(get_tree().create_timer(0.7), "timeout")
	_changeScene = get_tree().change_scene("res://Scenes/boyScenes/boyQuizScreen.tscn")

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
	_changeScene = get_tree().change_scene("res://Scenes/boyScenes/boyGameScene.tscn")
	
func canHideMenu():
	$menuSpawn.hide()

func onRankingButtonPressed():
	ProjectManager.loadData()
	canChangeScene = ProjectManager.quizResult.hasInternet
	print(canChangeScene)
	if  canChangeScene == true:
		_changeScene = get_tree().change_scene("res://addons/silent_wolf/Scores/Leaderboard.tscn")
