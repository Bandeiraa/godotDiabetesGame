extends Control

onready var menuAnimation = get_node("Animator")
var _changeSceneTo

func _ready():
	ProjectManager.loadData()
	if ProjectManager.quizResult.hasInternet == true:
		$registerButton.hide()
		$loginButton.hide()
		
	menuAnimation.play("BlinkANimation")
	SilentWolf.configure({
		"api_key": "jB8i3p4pfc3C1QGgSZqtS39J7TToMy4Y96UTv916",
		"game_id": "Englicosados",
		"game_version": "1.0.0",
		"log_level": 1
	})

	SilentWolf.configure_scores({
		"open_scene_on_close": "res://Scenes/InitialScreen.tscn"
	})
	

func onBoyButtonPressed():
	menuAnimation.play("BlinkScreen")
	yield(get_tree().create_timer(0.7), "timeout")
	_changeSceneTo = get_tree().change_scene("res://Scenes/boyScenes/boyPrincipal.tscn")

func onGirlButtonPressed():
	menuAnimation.play("BlinkScreen")
	yield(get_tree().create_timer(0.7), "timeout")
	_changeSceneTo = get_tree().change_scene("res://Scenes/girlScenes/girlPrincipal.tscn")

func onRegisterPressed() -> void:
	_changeSceneTo = get_tree().change_scene("res://Scenes/register.tscn")

func onLoginPressed() -> void:
	_changeSceneTo = get_tree().change_scene("res://Scenes/login.tscn")

func onLeaderboardPressed():
	_changeSceneTo = get_tree().change_scene("res://Scenes/leaderBoard.tscn")
