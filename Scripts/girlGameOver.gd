extends Control

var _changeScene
var storePoints
onready var blinkAnim = get_node("BlinkScreenAnimator")
onready var points : Label = $LabelLayer/TotalPoints
onready var glucoseStored : Label = $LabelLayer/GlucosePoints
onready var nameLabel : LineEdit = $SaveScorePopup/SaveScoreContainer/ScoreName
onready var gameOverMessage : TextureRect = $InterfaceContainer/GameOverMessage
onready var saveScoreContainer : TextureRect = $SaveScorePopup/SaveScoreContainer
onready var saveScorePopup : TextureRect = $SaveScorePopup

func _process(_delta):
	var getSavedName = nameLabel.text
	$SaveScorePopup/SaveScoreContainer/ScoreNameAux.text = getSavedName
	
func _ready():
	ProjectManager.loadData()
	storePoints = int(ProjectManager.quizResult.totalScore)
	var storeGlucoseAmount = ProjectManager.quizResult.glucoseAmount
	var gameOverHypo = ProjectManager.quizResult.gameOverHypo
	var gameOverHyper = ProjectManager.quizResult.gameOverHyper
	#var gameOverDN = ProjectManager.quizResult.gameOverHyper
	var hasInternet = ProjectManager.quizResult.hasInternet
	if hasInternet == true:
		saveScorePopup.set_visible(true)
		if gameOverHypo == true:
			gameOverMessage.texture = load("res://Assets/Sprites/EndSprites/GameOver/Girl/hypoglicemiaGO.png")
		elif gameOverHyper == true:
			gameOverMessage.texture = load("res://Assets/Sprites/EndSprites/GameOver/Girl/highGlucoseGO.png")
		else:
			gameOverMessage.texture = load("res://Assets/Sprites/EndSprites/GameOver/Girl/doNothingGO.png")
	else:
		saveScorePopup.set_visible(false)
		if gameOverHypo == true:
			gameOverMessage.texture = load("res://Assets/Sprites/EndSprites/GameOver/Girl/hypoglicemiaGO.png")
		elif gameOverHyper == true:
			gameOverMessage.texture = load("res://Assets/Sprites/EndSprites/GameOver/Girl/highGlucoseGO.png")
		else:
			gameOverMessage.texture = load("res://Assets/Sprites/EndSprites/GameOver/Girl/doNothingGO.png")
	glucoseStored.text = storeGlucoseAmount 
	points.text = str(storePoints)
	
func onTryAgainButtonPressed():
	PopupButton.play()
	ProjectManager.loadData()
	ProjectManager.quizResult.totalScore = 0
	ProjectManager.quizResult.glucoseAmount = "70"
	ProjectManager.quizResult.candiesCount = 0
	ProjectManager.quizResult.increasedSpawn = 0 
	ProjectManager.quizResult.increasedGlucoseAmount = 0
	ProjectManager.quizResult.gameOverHyper = false
	ProjectManager.quizResult.gameOverHypo = false
	if ProjectManager.quizResult.bonus == 0:
		ProjectManager.quizResult.bonus = 0
	else:
		ProjectManager.quizResult.bonus = 1
	ProjectManager.save()
	blinkAnim.play("blinkAnim")
	yield(get_tree().create_timer(0.7), "timeout")
	_changeScene = get_tree().change_scene("res://Scenes/EndScenes/Game/Girl/GameScene.tscn")
	
func onInitialScreenButtonPressed():
	PopupButton.play()
	ProjectManager.quizResult.totalScore = 0
	ProjectManager.quizResult.glucoseAmount = "70"
	ProjectManager.quizResult.candiesCount = 0
	ProjectManager.quizResult.increasedSpawn = 0 
	ProjectManager.quizResult.increasedGlucoseAmount = 0
	if ProjectManager.quizResult.bonus == 1:
		ProjectManager.quizResult.youLost = false
	else:
		ProjectManager.quizResult.youLost = true
	ProjectManager.save()
	MainGameSong.stop()
	InitialSong.play()
	blinkAnim.play("blinkAnim")
	yield(get_tree().create_timer(0.7), "timeout")
	_changeScene = get_tree().change_scene("res://Scenes/MiddleScenes/Main/Girl/Main.tscn")
	
func onSaveButtonPressed():
	var name = nameLabel.text
	SilentWolf.Scores.persist_score(name, storePoints)
	SilentWolf.Scores.get_high_scores()
	$SaveScorePopup/SaveScoreContainer.hide()
	$SaveTimer.start()
	
func _on_Button_pressed():
	_changeScene = get_tree().change_scene("res://addons/silent_wolf/Scores/Leaderboard.tscn")

func onYesButtonPressed():
	$SaveScorePopup/FirstPopup.hide()
	saveScoreContainer.set_visible(true)

func onNoButtonPressed():
	saveScorePopup.set_visible(false)

func onBackButtonPressed():
	saveScorePopup.set_visible(false)

func onSaveTimerTimeout():
	$SaveScorePopup/AfterSaveScoreContainer.show()
