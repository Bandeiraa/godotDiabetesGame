extends Control

var randIndex; var storedRandomNumber; var data
var storedText; var storedFile; var storedParse; var readFile
var questionNumber = 0; var _changeScene; var maxNumberOfQuestions
var storedRandomNumberAux; var array; var arrayAux; var dataStore; var wrongAnswer = 0
var pointsCount = 0; signal canIncreasePoints; var pointsCountAux = 0

onready var jsonFile = 'res://Assets/Questions/Quiz.json'
onready var answerReaction = get_node("GirlAnimator")
onready var buttonAnimator = get_node("ButtonAnimator")
onready var timeWait = get_node("Timer")
onready var timePopup = get_node("popupTimer")

var savePath = "user://save.dat"

func _ready():
	loadJson()
	maxNumberOfQuestions = data.perguntas.size()
	nextQuestion()

func loadJson():
	randomize()
	storedFile = File.new()
	readFile = storedFile.READ
	storedFile.open(jsonFile, readFile)
	storedText = storedFile.get_as_text()
	storedParse = JSON.parse(storedText)
	data = storedParse.result
	storedRandomNumber = randi() % data.perguntas.size()

func nextQuestion():
	questionNumber += 1
	$Question.text = data.perguntas[storedRandomNumber].questao.enunciado
	var answersSize = data.perguntas[storedRandomNumber].questao.respostas.size()
	array = [0, 1, 2, 3]
	array.shuffle()
	arrayAux = [0, 1]
	arrayAux.shuffle()
	
	if answersSize >= 4:
		$SecondVerticalBox.set_visible(false)
		$VerticalBox.set_visible(true)
		$VerticalBox/firstButton/firstItem.text = data.perguntas[storedRandomNumber].questao.respostas[array[0]]
		$VerticalBox/secondButton/secondItem.text = data.perguntas[storedRandomNumber].questao.respostas[array[1]]
		$VerticalBox/thirdButton/thirdItem.text = data.perguntas[storedRandomNumber].questao.respostas[array[2]]
		$VerticalBox/fourthButton/fourthItem.text = data.perguntas[storedRandomNumber].questao.respostas[array[3]]
	if answersSize == 2:
		$VerticalBox.set_visible(false)
		$SecondVerticalBox.set_visible(true)
		$SecondVerticalBox/firstButton/firstItem.text = data.perguntas[storedRandomNumber].questao.respostas[arrayAux[0]]
		$SecondVerticalBox/secondButton/secondItem.text = data.perguntas[storedRandomNumber].questao.respostas[arrayAux[1]]

func removeQuestion():
	if data.perguntas.size() - 1 == 0:
		var totalPoints
		if wrongAnswer == 0:
			totalPoints = str(100, "/", 100)
		else:
			totalPoints = str(pointsCount * 5, "/", (wrongAnswer + pointsCount) * 5) 
		ProjectManager.quizResult.totalPoints = totalPoints
		ProjectManager.quizResult.correctAnswers = pointsCount
		ProjectManager.quizResult.wrongAnswers = wrongAnswer
		ProjectManager.quizResult.bonus = 1
		ProjectManager.save()
		answerReaction.play("fadeOut")
		yield(get_tree().create_timer(0.7), "timeout")
		_changeScene = get_tree().change_scene("res://Scenes/girlScenes/girlPrincipalScreenAfterQuiz.tscn")
		return 
	data.perguntas.remove(storedRandomNumber)
	storedRandomNumber = randi() % data.perguntas.size()
	
func onFirstButtonPressed():
	var firstButtonText = $VerticalBox/firstButton/firstItem.text
	var firstButtonTextAux = $SecondVerticalBox/firstButton/firstItem.text
	if checkCorrectAnswer(firstButtonText) == true: 
		buttonAnimator.play("correctAnswer")
	elif checkCorrectAnswerAux(firstButtonTextAux) == true:
		buttonAnimator.play("correctAnswer")
	else:
		buttonAnimator.play("falseAnswer")
	removeQuestion()
	timeWait.start()

func onSecondButtonPressed():
	var secondButtonText = $VerticalBox/secondButton/secondItem.text
	var secondButtonTextAux = $SecondVerticalBox/secondButton/secondItem.text
	if checkCorrectAnswer(secondButtonText) == true: 
		buttonAnimator.play("correctAnswer2nd")
	elif checkCorrectAnswerAux(secondButtonTextAux) == true:
		buttonAnimator.play("correctAnswer2nd")
	else:
		buttonAnimator.play("falseAnswer2nd")
	removeQuestion()
	timeWait.start()
	
func onThirdButtonPressed():
	var thirdButtonText = $VerticalBox/thirdButton/thirdItem.text
	if checkCorrectAnswer(thirdButtonText) == true:
		buttonAnimator.play("correctAnswer3rd")
	else:
		buttonAnimator.play("falseAnswer3rd")
	removeQuestion()
	timeWait.start()
	
func onFourthButtonPressed():
	var fourthButtonText = $VerticalBox/fourthButton/fourthItem.text
	if checkCorrectAnswer(fourthButtonText) == true:
		buttonAnimator.play("correctAnswer4th")
	else:
		buttonAnimator.play("falseAnswer4th")
	removeQuestion()
	timeWait.start()
	
func checkCorrectAnswer(button):
	var answersSize = data.perguntas[storedRandomNumber].questao.respostas.size()
	var AnswerCorrect = data.perguntas[storedRandomNumber].questao.correta
	if answersSize == 4:
		if button == AnswerCorrect:
			pointsCount += 1
			print("Fez um total de: ", pointsCount)
			answerReaction.play("rightAnswer")
			emit_signal("canIncreasePoints")
			if pointsCount == 5:
				timePopup.start()
			return true
		else:
			answerReaction.play("wrongAnswer")
			wrongAnswer += 1
	

func checkCorrectAnswerAux(button):
	var answersSize = data.perguntas[storedRandomNumber].questao.respostas.size()
	var AnswerCorrect = data.perguntas[storedRandomNumber].questao.correta
	if answersSize == 2:
		if button == AnswerCorrect:
			pointsCount += 1
			print("Qtde de acertos: ", pointsCount)
			answerReaction.play("rightAnswer")
			emit_signal("canIncreasePoints")
			if pointsCount == 5:
				timePopup.start()
			return true
		else:
			answerReaction.play("wrongAnswer")
			wrongAnswer += 1
			
func onPointsAreIncreased():
	pointsCountAux += 1

func onBackButtonPressed():
	answerReaction.play("fadeOut")
	yield(get_tree().create_timer(0.7), "timeout")
	_changeScene = get_tree().change_scene("res://Scenes/girlScenes/girlPrincipal.tscn")

func onTimerTimeout():
	print("Questoes Erradas: ", wrongAnswer)
	nextQuestion()
	
func onConfirmButtonPressed():
	var totalPoints
	if wrongAnswer == 0:
		totalPoints = str(25, "/", 25)
	else:
		totalPoints = str(25, "/", (wrongAnswer + pointsCount) * 5) 
	ProjectManager.quizResult.totalPoints = totalPoints
	ProjectManager.quizResult.correctAnswers = pointsCount
	ProjectManager.quizResult.wrongAnswers = wrongAnswer
	ProjectManager.quizResult.bonus = 1
	ProjectManager.save()
	answerReaction.play("fadeOut")
	yield(get_tree().create_timer(0.7), "timeout")
	_changeScene = get_tree().change_scene("res://Scenes/girlScenes/girlPrincipalScreenAfterQuiz.tscn")
		
func onRefuseButtonPressed():
	$popupMenu.set_visible(false)

func onPopupTimeout():
	$popupMenu.set_visible(true)
