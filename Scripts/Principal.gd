extends Control

var _changeScene
var menuScene
var resultScene
var canChangeScene = false
var menuInstanced

func _ready():
	menuScene = preload("res://Scenes/InterfaceScenes/Boy/ConfigMenu.tscn")
	resultScene = preload("res://Scenes/MiddleScenes/QuizResult/Boy/Result.tscn")
	var quizResult = resultScene.instance()
	ProjectManager.loadData()
	if ProjectManager.quizResult.hasInternet == true:
		$RankingButton.show()
	else:
		$RankingButton.hide()
		
	if ProjectManager.quizResult.quizDone == true:
		$Spawn.show()
		$Spawn.add_child(quizResult)
		$Spawn/QuizResult/Container/TotalPoints.text = str(ProjectManager.quizResult.totalPoints)
		$Spawn/QuizResult/Container/RightAnswers.text = str(ProjectManager.quizResult.correctAnswers)
		$Spawn/QuizResult/Container/WrongAnswers.text = str(ProjectManager.quizResult.wrongAnswers)
		$QuizButton.hide()
	else:
		$Spawn.hide()
	if ProjectManager.quizResult.youLost == true:
		ProjectManager.quizResult.bonus = 0
		ProjectManager.save()
	
func onGearPressed():
	BlinkAnimation.canGearPlay()
	ConfigPopup.play()
	yield(get_tree().create_timer(0.9), "timeout")
	$Spawn.show()
	menuInstanced = menuScene.instance()
	$Spawn.add_child(menuInstanced)
	menuInstanced.connect("canHide", self, "canHideMenu")
	
func onBackToSceneButtonPressed():
	$Menu.set_visible(false)

func onQuizButtonPressed():
	BlinkAnimation.canPlay()
	yield(get_tree().create_timer(0.7), "timeout")
	_changeScene = get_tree().change_scene("res://Scenes/MiddleScenes/Quiz/Boy/QuizScreen.tscn")

func onPlayButtonPressed():
	InitialSong.stop()
	MainGameSong.play()
	ProjectManager.quizResult.totalScore = 0
	ProjectManager.quizResult.glucoseAmount = "70"
	ProjectManager.quizResult.candiesCount = 0
	ProjectManager.save()
	BlinkAnimation.canPlay()
	yield(get_tree().create_timer(0.7), "timeout")
	_changeScene = get_tree().change_scene("res://Scenes/EndScenes/Game/Boy/GameScene.tscn")
	
func canHideMenu():
	$Spawn/ConfigMenu.hide()
	$Spawn.remove_child(menuInstanced)

func onRankingButtonPressed():
	ProjectManager.loadData()
	canChangeScene = ProjectManager.quizResult.hasInternet
	print(canChangeScene)
	if canChangeScene == true:
		BlinkAnimation.canPlay()
		yield(get_tree().create_timer(0.7), "timeout")
		_changeScene = get_tree().change_scene("res://addons/silent_wolf/Scores/Leaderboard.tscn")

func _onTutorialButtonPressed():
	_changeScene = OS.shell_open("https://youtu.be/0maVvJVzRR4")
