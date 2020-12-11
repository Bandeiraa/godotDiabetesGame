extends Node

const FILE_NAME = "user://game-data.json"

var quizResult = {
	"totalPoints": "100/100",
	"correctAnswers": 0,
	"wrongAnswers": 0,
	"glucoseAmount": "70",
	"totalScore": 0
}

func save():
	var file = File.new()
	file.open(FILE_NAME, File.WRITE)
	file.store_string(to_json(quizResult))
	file.close()
	
func loadData():
	var file = File.new()
	if file.file_exists(FILE_NAME):
		file.open(FILE_NAME, File.READ)
		var data = parse_json(file.get_as_text())
		file.close()
		if typeof(data) == TYPE_DICTIONARY:
			quizResult = data
		else:
			printerr("Error")
	else:
		printerr("No saved data!")
