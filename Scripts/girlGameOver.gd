extends Control

var _changeScene
var storePoints
onready var blinkAnim = get_node("BlinkScreenAnimator")
onready var points : Label = $LabelLayer/TotalPoints
onready var glucoseStored : Label = $LabelLayer/GlucosePoints
onready var nameLabel : LineEdit = $LineEdit
onready var gameOverMessage : TextureRect = $InterfaceContainer/GameOverMessage

func _ready():
	ProjectManager.loadData()
	storePoints = ProjectManager.quizResult.totalScore
	var storeGlucoseAmount = ProjectManager.quizResult.glucoseAmount
	var gameOverHypo = ProjectManager.quizResult.gameOverHypo
	var gameOverHyper = ProjectManager.quizResult.gameOverHyper
	#var gameOverDN = ProjectManager.quizResult.gameOverHyper
	var hasInternet = ProjectManager.quizResult.hasInternet
	if hasInternet == true:
		if gameOverHypo == true:
			gameOverMessage.texture = load("res://Assets/Sprites/girlGameOverSprites/hypoglicemiaGO.png")
		elif gameOverHyper == true:
			gameOverMessage.texture = load("res://Assets/Sprites/girlGameOverSprites/highGlucoseGO.png")
		else:
			gameOverMessage.texture = load("res://Assets/Sprites/girlGameOverSprites/doNothingGO.png")
	else:
		if gameOverHypo == true:
			gameOverMessage.texture = load("res://Assets/Sprites/girlGameOverSprites/hypoglicemiaGO.png")
		elif gameOverHyper == true:
			gameOverMessage.texture = load("res://Assets/Sprites/girlGameOverSprites/highGlucoseGO.png")
		else:
			gameOverMessage.texture = load("res://Assets/Sprites/girlGameOverSprites/doNothingGO.png")
	glucoseStored.text = storeGlucoseAmount 
	points.text = str(storePoints)
	
func onTryAgainButtonPressed():
	ProjectManager.quizResult.totalScore = 0
	ProjectManager.quizResult.glucoseAmount = "70"
	ProjectManager.quizResult.candiesCount = 0
	ProjectManager.quizResult.increasedSpawn = 0 
	ProjectManager.quizResult.increasedGlucoseAmount = 0
	ProjectManager.quizResult.gameOverHyper = false
	ProjectManager.quizResult.gameOverHypo = false
	ProjectManager.save()
	blinkAnim.play("blinkAnim")
	yield(get_tree().create_timer(0.7), "timeout")
	_changeScene = get_tree().change_scene("res://Scenes/girlScenes/girlGameScene.tscn")
	
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
	_changeScene = get_tree().change_scene("res://Scenes/girlScenes/girlPrincipal.tscn")
	
func onSaveButtonPressed():
	var name = $"LineEdit".text
	SilentWolf.Scores.persist_score(name, storePoints)
	SilentWolf.Scores.get_high_scores()
	pass
	
func _on_Button_pressed():
	_changeScene = get_tree().change_scene("res://addons/silent_wolf/Scores/Leaderboard.tscn")
