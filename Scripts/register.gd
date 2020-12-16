extends Control

onready var http : HTTPRequest = $HTTPRequest
onready var username : LineEdit = $Container/loginLabelEdit
onready var confirmUsername : LineEdit = $Container/confirmLoginLabelEdit
onready var password : LineEdit = $Container/passwordLabelEdit
onready var notification : Label = $Container/notificationLabel

var _changeScene

func _process(_delta):
	var getLoginTextToLabel = username.text
	var getConfirmLoginTextToLabel = confirmUsername.text
	var getPasswordTextToLabel = password.text
	$Container/loginLabel.text = getLoginTextToLabel
	$Container/confirmLoginLabel.text = getConfirmLoginTextToLabel
	$Container/passwordLabel.text = getPasswordTextToLabel
	
func _on_HTTPRequest_request_completed(_result, response_code, _headers, body):
	var _responseBody := JSON.parse(body.get_string_from_ascii())
	
	if response_code == 200:
		notification.text = "Registrado com sucesso!"
		notification.set("custom_colors/font_color",Color(0,1,0))
		yield(get_tree().create_timer(2.0), "timeout")
		_changeScene = get_tree().change_scene("res://Scenes/login.tscn")
	else:
		match (_responseBody.result.error.message.capitalize()):
			"Email Exists":
				notification.text = "Email já registrado"
				yield(get_tree().create_timer(2.0), "timeout")
				notification.text = ""
			"Invalid Email":
				notification.text = "Formato de Email inválido, tente novamente"
				yield(get_tree().create_timer(2.0), "timeout")
				notification.text = ""
			"Missing Password":
				notification.text = "Por favor, preencha todos os campos"
				yield(get_tree().create_timer(2.0), "timeout")
				notification.text = ""
			"Weak Password : Password Should Be At Least 6 Characters":
				notification.text = "Por favor, digite pelo menos 6 digitos para a sua senha"
				yield(get_tree().create_timer(2.0), "timeout")
				notification.text = ""

func onRegisterButtonPressed() -> void:
	if username.text != confirmUsername.text:
		notification.text = "Os emails não correspondem um com o outro"
		return
	Firebase.register(username.text, password.text, http)
