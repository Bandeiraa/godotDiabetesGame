extends Control

onready var firstPerson : Label = $HBoxContainer/Label
onready var secondPerson : Label = $HBoxContainer/Label2
onready var thirdPerson : Label = $HBoxContainer/Label3
onready var fourthPerson : Label = $HBoxContainer/Label4
onready var fifthPerson : Label = $HBoxContainer/Label5
onready var httpRequest : HTTPRequest = $HTTPRequest

var informationSent = true

var profile := {
	"points": {},
	"name": {}
} setget setProfile

func _ready():
	Firebase.getDocument("users" % Firebase.user_info.id, httpRequest)

func _on_HTTPRequest_request_completed(result: int, response_code: int, headers: PoolStringArray, body: PoolByteArray):
	var result_body := JSON.parse(body.get_string_from_ascii()).result as Dictionary
	if response_code == 200:
		informationSent = false
		firstPerson
	#self.profile = result_body.fields

func onLoadButtonPressed():
	profile.firstPerson = {"stringValue": firstPerson.text}
	#profile.name = {"stringValue": nameLabel.text}
	
	informationSent = true
	#firstPerson.text = 
	
func setProfile(value: Dictionary) -> void:
	profile = value
	firstPerson.text = profile.points.stringValue #Just turn on if you want to change the value when re enter the scene

