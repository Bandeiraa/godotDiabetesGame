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
	ProjectManager.save()
	#print(ProjectManager.quizResult.glucoseAmount)
	blinkAnim.play("blinkAnim")
	yield(get_tree().create_timer(0.7), "timeout")
	_changeScene = get_tree().change_scene("res://Scenes/girlScenes/girlGameScene.tscn")

func onInitialScreenButtonPressed():
	ProjectManager.quizResult.totalScore = 0
	ProjectManager.quizResult.glucoseAmount = "70"
	ProjectManager.save()
	MainGameSong.stop()
	InitialSong.play()
	blinkAnim.play("blinkAnim")
	yield(get_tree().create_timer(0.7), "timeout")
	_changeScene = get_tree().change_scene("res://Scenes/girlScenes/girlPrincipal.tscn")
