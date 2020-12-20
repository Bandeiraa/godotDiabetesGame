extends Control

onready var http : HTTPRequest = $HTTPRequest
onready var username : LineEdit = $Container/LoginLabelEdit
onready var confirmUsername : LineEdit = $Container/ConfirmLoginLabelEdit
onready var password : LineEdit = $Container/PasswordLabelEdit
onready var notification : Label = $Container/NotificationLabel

var _changeScene

func _process(_delta):
	var getLoginTextToLabel = username.text
	var getConfirmLoginTextToLabel = confirmUsername.text
	var getPasswordTextToLabel = password.text
	$Container/LoginLabel.text = getLoginTextToLabel
	$Container/ConfirmLoginLabel.text = getConfirmLoginTextToLabel
	$Container/PasswordLabel.text = getPasswordTextToLabel
	
func _on_HTTPRequest_request_completed(_result, response_code, _headers, body):
	var _responseBody := JSON.parse(body.get_string_from_ascii())
	if response_code == 200:
		notification.text = "Registrado com sucesso!"
		notification.set("custom_colors/font_color",Color(0,1,0))
		yield(get_tree().create_timer(2.0), "timeout")
		_changeScene = get_tree().change_scene("res://Scenes/InitialScenes/Authentication/Login.tscn")
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
