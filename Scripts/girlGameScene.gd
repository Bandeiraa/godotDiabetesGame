extends Node2D

var FRUITS = [preload("res://Scenes/fruitsScenes/lettuce.tscn"), preload("res://Scenes/fruitsScenes/banana.tscn"), preload("res://Scenes/fruitsScenes/eggplant.tscn"), preload("res://Scenes/fruitsScenes/carrot.tscn"),
			  preload("res://Scenes/fruitsScenes/orange.tscn"), preload("res://Scenes/fruitsScenes/pear.tscn"), preload("res://Scenes/fruitsScenes/bellPepper.tscn"), preload("res://Scenes/fruitsScenes/tomatoe.tscn"),
			  preload("res://Scenes/fruitsScenes/strawberry.tscn")]
			
var CANDIES = [preload("res://Scenes/candiesScenes/frenchFries.tscn"), preload("res://Scenes/candiesScenes/cookie.tscn"), preload("res://Scenes/candiesScenes/chocolate.tscn"),
			   preload("res://Scenes/candiesScenes/cake.tscn"), preload("res://Scenes/candiesScenes/brigadeiro.tscn"), preload("res://Scenes/candiesScenes/sandwich.tscn"),
			   preload("res://Scenes/candiesScenes/sugar.tscn")]
			
onready var glucoseValue = $layer/glucoseLabel
onready var fruitPosition = get_node("FruitPosition")
onready var candiePosition = get_node("CandiePosition")
onready var fruitsTimer = $fruitsTimer
onready var candiesTimer = $candiesTimer
onready var blinkAnim = $animator
onready var warningAnimator = $warningAnimator
onready var fadeAnimation = $blinkScreenAnimator

var storeData = 0
var canFreezeGlucose = false
var glucoseCalculus = 70
var candiesCount = 0
var pointsCount = 0
var randomGlucoseValue; var storeValue = 0
var aux = 0; var aux2 = 0
var _changeScene; var isOutside = false
var storedPointsValue
var storedGlucoseValue
var randomFruitPosition
var randomCandiePosition
var sum = 0

func _ready():
	onBackToScene()
	
func onBackToScene():
	ProjectManager.loadData()
	storedPointsValue = int(ProjectManager.quizResult.totalScore)
	$layer/pointsCountLabel.text = str(storedPointsValue)
	storedGlucoseValue = str(ProjectManager.quizResult.glucoseAmount)
	#print(storedGlucoseValue)
	glucoseCalculus = int(storedGlucoseValue)
	glucoseValue.text = str(glucoseCalculus)
	candiesCount = int(ProjectManager.quizResult.candiesCount)
	print(candiesCount)
	print(ProjectManager.quizResult.bonus)
	if ProjectManager.quizResult.bonus == 1:
		$bonusButton.set_visible(true)
	else:
		$bonusButton.set_visible(false)
	#print(glucoseValue.text)

func spawnFruit():
	fruitsTimer.start()
	randomize()
	var randomTimerIndex = rand_range(0.3, 1.5)
	fruitsTimer.set_wait_time(randomTimerIndex)
	var fruit = respawnFruit(FRUITS).instance()
	fruitPosition = Vector2()
	randomFruitPosition = int(rand_range(23, 125))
	print("Valor random quando a distancia eh maior do que 40 ", randomFruitPosition)
	#fruitPosition.x = randomFruitPosition
	var distanceBtw = abs(randomFruitPosition - randomCandiePosition)
	print("Distancia entre doce x fruta: ", distanceBtw)
	#print("Distance between fruit x candy ", distanceBtw)
	#print("Random Value outside If ", randomFruitPosition)
	#print(distance)
	if  distanceBtw <= 40:
		randomize()
		randomFruitPosition = int(rand_range(23, 125))
		print("Valor random quando a distancia fica menor do que 40 ", randomFruitPosition)
		#print("Random Value inside If ", randomFruitPosition)
		#randomCandiePosition = int(rand_range(-58, 58))
		fruitPosition.x = randomFruitPosition
		fruit.set_position(fruitPosition)
		$FruitPosition.add_child(fruit)
		#print("Entrou no if")
		#print("Novo valor random ", randomFruitPosition)
	else:
		fruitPosition.x = randomFruitPosition
		fruit.set_position(fruitPosition)
		#print("Spawnou uma fruta na posicao: ", fruitPosition.x)
		$FruitPosition.add_child(fruit)
	fruit.connect("fruitDestroyed", self, "canIncreasePointsCount")
		
func spawnCandie():
	candiesTimer.start()
	randomize()
	var randomTimerIndex = rand_range(1.5, 3.0)
	candiesTimer.set_wait_time(randomTimerIndex)
	var candie = respawnCandie(CANDIES).instance()
	candiePosition = Vector2()
	randomCandiePosition = int(rand_range(23, 125))
	candiePosition.x = randomCandiePosition
	#if randomCandiePosition - randomFruitPosition <= abs(50):
	#	randomCandiePosition = int(rand_range(-58, 58))
	#if candiePosition.x && fruitPosition.x:
	candie.set_position(candiePosition)
	#print("Spawnou um doce na posicao: ", candiePosition.x)
	$CandiePosition.add_child(candie)
	candie.connect("candyDestroied", self, "canIncreaseGlucose")
	
func respawnFruit(choice):
	randomize()
	var randomIndex = randi() % choice.size()
	return choice[randomIndex]
	pass 
	
func respawnCandie(choice):
	randomize()
	var randomIndex = randi() % choice.size()
	return choice[randomIndex]
	pass
	
func onFruitTimerTimeout():
	spawnFruit()

func onCandieTimerTimeout():
	spawnCandie()
	
func canIncreasePointsCount():
	randomize()
	if canFreezeGlucose == false:
		aux2 = int(rand_range(5, 20))
		storeValue += aux2
		glucoseCalculus = glucoseCalculus + storeValue#int(storedGlucoseValue)  #int(storedGlucoseValue)
		glucoseValue.text = str(glucoseCalculus)
		pointsCount += 20
		sum = pointsCount + storedPointsValue
		$layer/pointsCountLabel.text = str(sum)
	elif canFreezeGlucose == true:
		pointsCount += 20
		sum = pointsCount + storedPointsValue
		$layer/pointsCountLabel.text = str(sum)
	storeValue = 0
	
func canIncreaseGlucose():
	randomize()
	if canFreezeGlucose == false:
		candiesCount += 1
		var randomCandieValue = int(rand_range(5, candiesCount))
		print(randomCandieValue)
		glucoseCalculus = glucoseCalculus + randomCandieValue
		glucoseValue.text = str(glucoseCalculus)
	elif canFreezeGlucose == true:
		pass

func onGlucoseTimerTimeout():
	randomize()
	randomGlucoseValue = int(rand_range(5, 15))
	aux += randomGlucoseValue #+ glucoseCalculus
	glucoseCalculus = glucoseCalculus - aux #int(storedGlucoseValue)
	#print(glucoseCalculus) 
	glucoseValue.text = str(glucoseCalculus)
	aux = 0
	
func _process(_delta):
	if glucoseCalculus >= 160 && glucoseCalculus <= 189:
		warningAnimator.play("warningLabel")
		$exerciseSpriteAux.set_visible(false)
		blinkAnim.play("blinkWarningExercise")
		isOutside = true
	else:
		#glucoseValue.set("custom_colors/font_color", Color(1,1,1))
		$exerciseSpriteAux.set_visible(true)
		if isOutside == true:
			$warningAnimator.seek(0)
			isOutside = false
		
	if glucoseCalculus >= 190:
		$glucoseTimer.stop()
		$qtePopup.set_visible(true)
		$exerciseButtonScene.set_visible(true)
		$insulinButtonScene.set_visible(true)
		$doNothingButtonScene.set_visible(true)
	else:
		$qtePopup.set_visible(false)
		$exerciseButtonScene.set_visible(false)
		$insulinButtonScene.set_visible(false)
		$doNothingButtonScene.set_visible(false)
		
	if(glucoseCalculus >= 30 && glucoseCalculus <= 70):
		warningAnimator.play("warningLabel")
		$warningMessage.set_visible(true)
		blinkAnim.play("blinkWarning")
		#isOutside = true
	elif glucoseCalculus <= 30:
		ProjectManager.quizResult.glucoseAmount = str(glucoseCalculus)
		ProjectManager.quizResult.totalScore = sum
		ProjectManager.save()
		fadeAnimation.play("blinkScreen")
		_changeScene = get_tree().change_scene("res://Scenes/girlScenes/hypoglycemiaGameOver.tscn")
		
	else:
		$warningMessage.set_visible(false)
		
func onDNothingButtonPressed():
	ProjectManager.quizResult.glucoseAmout = str(glucoseCalculus)
	ProjectManager.quizResult.totalScore = pointsCount
	ProjectManager.save()
	fadeAnimation.play("blinkScreen")
	yield(get_tree().create_timer(0.7), "timeout")
	_changeScene = get_tree().change_scene("res://Scenes/girlScenes/highGlucoseGameOver.tscn")

func onExerciseButtonPressed():
	randomize()
	var randomExercise
	randomExercise = randi() % 2 + 1
	if glucoseCalculus >= 160 && glucoseCalculus <= 189:
		var randomGlucoseValueAux
		randomGlucoseValueAux = int(rand_range(60, 80))
		#print(randomGlucoseValueAux)
		glucoseCalculus = glucoseCalculus - randomGlucoseValueAux
		print(glucoseCalculus)
		ProjectManager.quizResult.glucoseAmount = str(glucoseCalculus)
		if sum <= 1000:
			ProjectManager.quizResult.totalScore = str("0", sum)
		else:
			ProjectManager.quizResult.totalScore = sum
		ProjectManager.quizResult.candiesCount = candiesCount
		print(candiesCount)
		ProjectManager.save()
		var storeScenePath = str("res://Scenes/girlScenes/girlExercise", str(randomExercise), ".tscn")
		_changeScene = get_tree().change_scene(storeScenePath)

func onInsulinButtonPressed():
	glucoseCalculus = glucoseCalculus - 100
	glucoseValue.text = str(glucoseCalculus)
	$glucoseTimer.start()
	pass # Replace with function body.

func onBonusPressed():
	$glucoseTimer.stop()
	$bonusTimer.start()
	canFreezeGlucose = true
	$bonusButton.set_visible(false)

func onBonusEnd():
	$glucoseTimer.start()
	canFreezeGlucose = false
