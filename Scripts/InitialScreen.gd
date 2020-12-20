extends Control

onready var menuAnimation = get_node("Animator")
var _changeSceneTo

func _ready():
	ProjectManager.loadData()
	if ProjectManager.quizResult.hasInternet == true:
		$RegisterButton.hide()
		$LoginButton.hide()

	SilentWolf.configure({
		"api_key": "jB8i3p4pfc3C1QGgSZqtS39J7TToMy4Y96UTv916",
		"game_id": "Englicosados",
		"game_version": "1.0.0",
		"log_level": 1
	})
	
	SilentWolf.configure_scores({
		"open_scene_on_close": "res://Scenes/InitialScenes/Initial/CharacterSelectScreen.tscn"
	})
	
func onBoyButtonPressed():
	menuAnimation.play("BlinkScreen")
	yield(get_tree().create_timer(0.7), "timeout")
	_changeSceneTo = get_tree().change_scene("res://Scenes/MiddleScenes/Main/Boy/Main.tscn")

func onGirlButtonPressed():
	menuAnimation.play("BlinkScreen")
	yield(get_tree().create_timer(0.7), "timeout")
	_changeSceneTo = get_tree().change_scene("res://Scenes/MiddleScenes/Main/Girl/Main.tscn")

func onRegisterPressed() -> void:
	_changeSceneTo = get_tree().change_scene("res://Scenes/InitialScenes/Authentication/Register.tscn")

func onLoginPressed() -> void:
	_changeSceneTo = get_tree().change_scene("res://Scenes/InitialScenes/Authentication/Login.tscn")
