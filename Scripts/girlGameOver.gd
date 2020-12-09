extends Control

var _changeScene
var storePoints
var storeGlucoseAmount

func _ready():
	ProjectManager.loadData()
	storePoints = ProjectManager.quizResult.totalScore
	storeGlucoseAmount = ProjectManager.quizResult.glucoseAmout
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
	ProjectManager.quizResult.glucoseAmout = "70"
	ProjectManager.save()
	_changeScene = get_tree().change_scene("res://Scenes/girlScenes/girlGameScene.tscn")

func onInitialScreenButtonPressed():
	_changeScene = get_tree().change_scene("res://Scenes/girlScenes/girlPrincipal.tscn")
