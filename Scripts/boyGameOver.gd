extends Control

var _changeScene
var storePoints
var storeGlucoseAmount
onready var blinkAnim = get_node("AnimationPlayer")

func _ready():
	ProjectManager.loadData()
	storePoints = ProjectManager.quizResult.totalScore
	storeGlucoseAmount = ProjectManager.quizResult.glucoseAmount
	$layer/glucosePoints.text = storeGlucoseAmount 
	if storePoints < 10:
		$layer/totalPoints.text = str("000", storePoints)
	elif storePoints < 100:
		$layer/totalPoints.text = str("00", storePoints)
	elif storePoints < 1000:
		$layer/totalPoints.text = str("0", storePoints)
	else:
		$layer/totalPoints.text = str(storePoints)
	
func onTryAgainButtonPressed():
	ProjectManager.quizResult.totalScore = 0
	ProjectManager.quizResult.glucoseAmount = "70"
	ProjectManager.quizResult.candiesCount = 0
	ProjectManager.quizResult.increasedSpawn = 0 
	ProjectManager.quizResult.increasedGlucoseAmount = 0
	ProjectManager.save()
	#print(ProjectManager.quizResult.glucoseAmount)
	blinkAnim.play("blinkAnim")
	yield(get_tree().create_timer(0.7), "timeout")
	_changeScene = get_tree().change_scene("res://Scenes/boyScenes/boyGameScene.tscn")

func onInitialScreenButtonPressed():
	ProjectManager.quizResult.totalScore = 0
	ProjectManager.quizResult.glucoseAmount = "70"
	ProjectManager.quizResult.candiesCount = 0
	ProjectManager.quizResult.increasedSpawn = 0 
	ProjectManager.quizResult.increasedGlucoseAmount = 0
	ProjectManager.save()
	MainGameSong.stop()
	InitialSong.play()
	blinkAnim.play("blinkAnim")
	yield(get_tree().create_timer(0.7), "timeout")
	_changeScene = get_tree().change_scene("res://Scenes/boyScenes/boyPrincipal.tscn")

func _on_saveScoreButtonPressed_pressed():
	var name = $"LineEdit".text
	#SilentWolf.Scores.persist_score(name, storePoints)
	SilentWolf.Scores.persist_score(name, storePoints)
	SilentWolf.Scores.get_high_scores()

func load_leaderboard_screen():
	_changeScene = get_tree().change_scene("res://addons/silent_wolf/Scores/Leaderboard.tscn")
	
func _on_Button_pressed():
	load_leaderboard_screen()
