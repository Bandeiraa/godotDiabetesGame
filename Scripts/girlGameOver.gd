extends Control

var _changeScene
var storePoints
var storeGlucoseAmount
onready var blinkAnim = get_node("AnimationPlayer")
#onready var http : HTTPRequest = $HTTPRequest
onready var points : Label = $layer/totalPoints
onready var nameLabel : LineEdit = $LineEdit

#var newProfile := false
#var informationSent := false
#var profile := {
#	"points": {},
#	"name": {}
#} setget setProfile

func _ready():
	#Firebase.getDocument("users/%s" % Firebase.user_info.id, http)
	
	ProjectManager.loadData()
	storePoints = ProjectManager.quizResult.totalScore
	storeGlucoseAmount = ProjectManager.quizResult.glucoseAmount
	#points.text = str(storePoints)
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

#func _on_HTTPRequest_request_completed(result: int, response_code: int, headers: PoolStringArray, body: PoolByteArray) -> void:
#	var result_body := JSON.parse(body.get_string_from_ascii()).result as Dictionary
#	print(result_body)
#	match response_code:
#		404:
#			newProfile = true
#			return
#		200:
#			if informationSent:
#				informationSent = false
#			self.profile = result_body.fields
#			print(self.profile)

func onSaveButtonPressed():
	var name = $"LineEdit".text
	#SilentWolf.Scores.persist_score(name, storePoints)
	SilentWolf.Scores.persist_score(name, storePoints)
	SilentWolf.Scores.get_high_scores()
	#profile.points = {"stringValue": points.text}
	#profile.name = {"stringValue": nameLabel.text}
	#match newProfile:
	#	true:
	#		Firebase.saveDocument("users?documentId=%s" % Firebase.user_info.id, profile, http)
	#	false:
	#		Firebase.updateDocument("users/%s" % Firebase.user_info.id, profile, http)
	#informationSent = true
	#_changeScene = get_tree().change_scene("res://Scenes/leaderBoard.tscn")
	pass
	
func load_leaderboard_screen():
	_changeScene = get_tree().change_scene("res://addons/silent_wolf/Scores/Leaderboard.tscn")
#func setProfile(value: Dictionary) -> void:
#	profile = value
	#points.text = profile.points.stringValue #Just turn on if you want to change the value when re enter the scene
func _on_Button_pressed():
	load_leaderboard_screen()
	pass # Replace with function body.
