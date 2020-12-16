extends Control

onready var http : HTTPRequest = $HTTPRequest
onready var username : LineEdit = $Container/loginLabelEdit
onready var password : LineEdit = $Container/passwordLabelEdit
onready var notification : Label = $Container/notificationLabel
var _changeScene

func _process(_delta):
	var getLoginTextToLabel = username.text
	var getPasswordTextToLabel = password.text
	$Container/loginLabel.text = getLoginTextToLabel
	$Container/passwordLabel.text = getPasswordTextToLabel
	
func onLoginPressed():
	if username.text.empty() or password.text.empty():
		notification.text = "Por favor, insira o nome de usuário e a sua senha"
		return
	Firebase.login(username.text, password.text, http)
	
func _on_HTTPRequest_request_completed(_result, response_code, _headers, body):
	var _responseBody := JSON.parse(body.get_string_from_ascii())
	
	if response_code == 200:
		ProjectManager.quizResult.hasInternet = true
		ProjectManager.save()
		notification.text = "Login feito com sucesso!"
		notification.set("custom_colors/font_color",Color(0,1,0))
		yield(get_tree().create_timer(2.0), "timeout")
		_changeScene = get_tree().change_scene("res://Scenes/InitialScreenLogged.tscn")
	else:
		match (_responseBody.result.error.message.capitalize()):
			"Invalid Password":
				notification.text = "Senha inválida"
				yield(get_tree().create_timer(2.0), "timeout")
				notification.text = ""
			"Email Not Found":
				notification.text = "Email não registrado"
				yield(get_tree().create_timer(2.0), "timeout")
				notification.text = ""

