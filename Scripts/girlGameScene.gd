extends Node2D

var FRUITS = [preload("res://Scenes/FoodsScenes/FruitScene/Banana.tscn"), preload("res://Scenes/FoodsScenes/FruitScene/BellPepper.tscn"), preload("res://Scenes/FoodsScenes/FruitScene/Carrot.tscn"), preload("res://Scenes/FoodsScenes/FruitScene/Eggplant.tscn"),
			  preload("res://Scenes/FoodsScenes/FruitScene/Pear.tscn"), preload("res://Scenes/FoodsScenes/FruitScene/Lettuce.tscn"), preload("res://Scenes/FoodsScenes/FruitScene/Orange.tscn"), preload("res://Scenes/FoodsScenes/FruitScene/Strawberry.tscn"),
			  preload("res://Scenes/FoodsScenes/FruitScene/Tomatoe.tscn")]
			
var CANDIES = [preload("res://Scenes/FoodsScenes/CandieScene/Brigadeiro.tscn"), preload("res://Scenes/FoodsScenes/CandieScene/Cake.tscn"), preload("res://Scenes/FoodsScenes/CandieScene/Chocolate.tscn"),
			   preload("res://Scenes/FoodsScenes/CandieScene/Cookie.tscn"), preload("res://Scenes/FoodsScenes/CandieScene/FrenchFries.tscn"), preload("res://Scenes/FoodsScenes/CandieScene/Sandwich.tscn"),
			   preload("res://Scenes/FoodsScenes/CandieScene/Sugar.tscn")]
			
onready var glucoseValue = $layer/glucoseLabel
onready var fruitPosition = get_node("FruitPosition")
onready var candiePosition = get_node("CandiePosition")
onready var fruitsTimer = $fruitsTimer
onready var candiesTimer = $candiesTimer
onready var blinkAnim = $animator
onready var warningAnimator = $warningAnimator
onready var fadeAnimation = $blinkScreenAnimator

var spawnIncreaserValue = 0
var increaseGlucoseDecreasedValue = 0
var increaseFruitValue = 0
var pauseMenuScene
var storeData = 0
var canFreezeGlucose = false; var key = true; var keyAux = true
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
var candie
var fruit
var hasInternetConection

func _ready():
	onBackToScene()
	$dificultyTimer.start()
	pauseMenuScene = preload("res://Scenes/girlScenes/girlMenu.tscn")
	if increaseGlucoseDecreasedValue >= 10:
		$dificultyTimer.stop()
	
func onBackToScene():
	ProjectManager.loadData()
	hasInternetConection = ProjectManager.quizResult.hasInternet
	print(hasInternetConection)
	storedPointsValue = int(ProjectManager.quizResult.totalScore)
	$layer/pointsCountLabel.text = str(storedPointsValue)
	storedGlucoseValue = str(ProjectManager.quizResult.glucoseAmount)
	glucoseCalculus = int(storedGlucoseValue)
	glucoseValue.text = str(glucoseCalculus)
	candiesCount = int(ProjectManager.quizResult.candiesCount)
	print(candiesCount)
	print(ProjectManager.quizResult.bonus)
	spawnIncreaserValue = ProjectManager.quizResult.increasedSpawn
	increaseGlucoseDecreasedValue = ProjectManager.quizResult.increasedGlucoseAmount
	increaseFruitValue = ProjectManager.quizResult.increaseFruitValue 
	if ProjectManager.quizResult.bonus == 1:
		$bonusButton.set_visible(true)
	else:
		$bonusButton.set_visible(false)

func spawnFruit():
	fruitsTimer.start()
	randomize()
	var randomTimerIndex = rand_range(1 - spawnIncreaserValue, 1.5 - spawnIncreaserValue)
	fruitsTimer.set_wait_time(randomTimerIndex)
	fruit = respawnFruit(FRUITS).instance()
	fruitPosition = Vector2()
	randomFruitPosition = int(rand_range(23, 125))
	if (fruit.get_overlapping_areas().empty() == true):
		fruitPosition.x = randomFruitPosition
		fruit.set_position(fruitPosition)
		$FruitPosition.add_child(fruit)
	fruit.connect("fruitDestroyed", self, "canIncreasePointsCount")
	
func spawnCandie():
	candiesTimer.start()
	randomize()
	var randomTimerIndex = rand_range(1 - spawnIncreaserValue, 3 - spawnIncreaserValue)
	candiesTimer.set_wait_time(randomTimerIndex)
	candie = respawnCandie(CANDIES).instance()
	candiePosition = Vector2()
	randomCandiePosition = int(rand_range(23, 125))
	var randomCandieYPosition = int(rand_range(1, 10))
	if(candie.get_overlapping_areas().empty() == true):
		candiePosition.x = randomCandiePosition
		candiePosition.y = randomCandieYPosition
		candie.set_position(candiePosition)
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
		aux2 = int(rand_range(1, 5 + increaseFruitValue))
		storeValue += aux2
		glucoseCalculus = glucoseCalculus + storeValue
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
	randomGlucoseValue = int(rand_range(1 + increaseGlucoseDecreasedValue, 5 + increaseGlucoseDecreasedValue))
	aux += randomGlucoseValue
	glucoseCalculus = glucoseCalculus - aux 
	glucoseValue.text = str(glucoseCalculus)
	aux = 0
	
func _process(_delta):
	if glucoseCalculus >= 160 && glucoseCalculus <= 189:
		warningAnimator.play("warningLabel")
		$exerciseSpriteAux.set_visible(false)
		blinkAnim.play("blinkWarningExercise")
		isOutside = true
	else:
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
	elif glucoseCalculus <= 30:
		ProjectManager.quizResult.glucoseAmount = str(glucoseCalculus)
		ProjectManager.quizResult.totalScore = sum
		ProjectManager.save()
		fadeAnimation.play("blinkScreen")
		ProjectManager.quizResult.gameOverHypo = true
		ProjectManager.save()
		_changeScene = get_tree().change_scene("res://Scenes/girlScenes/girlGameOver.tscn")
	else:
		$warningMessage.set_visible(false)
		
func onDNothingButtonPressed():
	ProjectManager.quizResult.glucoseAmout = str(glucoseCalculus)
	ProjectManager.quizResult.totalScore = pointsCount
	ProjectManager.save()
	fadeAnimation.play("blinkScreen")
	yield(get_tree().create_timer(0.7), "timeout")
	ProjectManager.quizResult.gameOverDoNothing = true
	ProjectManager.save()
	_changeScene = get_tree().change_scene("res://Scenes/girlScenes/girlGameOver.tscn")
	
func onExerciseButtonPressed():
	randomize()
	var randomExercise
	randomExercise = randi() % 2 + 1
	if glucoseCalculus >= 160 && glucoseCalculus <= 189:
		var randomGlucoseValueAux
		randomGlucoseValueAux = int(rand_range(60, 80))
		glucoseCalculus = glucoseCalculus - randomGlucoseValueAux
		print(glucoseCalculus)
		ProjectManager.quizResult.glucoseAmount = str(glucoseCalculus)
		if sum <= 1000:
			ProjectManager.quizResult.totalScore = str("0", sum)
		else:
			ProjectManager.quizResult.totalScore = sum
		ProjectManager.quizResult.candiesCount = candiesCount
		print(candiesCount)
		ProjectManager.quizResult.increasedSpawn = spawnIncreaserValue 
		ProjectManager.quizResult.increasedGlucoseAmount = increaseGlucoseDecreasedValue
		ProjectManager.quizResult.increaseFruitValue = increaseFruitValue
		ProjectManager.save()
		var storeScenePath = str("res://Scenes/girlScenes/girlExercise", str(randomExercise), ".tscn")
		_changeScene = get_tree().change_scene(storeScenePath)

func onInsulinButtonPressed():
	ProjectManager.quizResult.glucoseAmount = str(glucoseCalculus)
	ProjectManager.quizResult.totalScore = sum
	ProjectManager.quizResult.candiesCount = candiesCount
	ProjectManager.quizResult.increasedSpawn = spawnIncreaserValue 
	ProjectManager.quizResult.increaseFruitValue = increaseFruitValue
	ProjectManager.quizResult.increasedGlucoseAmount = increaseGlucoseDecreasedValue
	ProjectManager.save()
	_changeScene = get_tree().change_scene("res://Scenes/girlScenes/insulinScene.tscn")

func onBonusPressed():
	$glucoseTimer.stop()
	$bonusTimer.start()
	canFreezeGlucose = true
	$bonusButton.set_visible(false)

func onBonusEnd():
	$glucoseTimer.start()
	canFreezeGlucose = false

func onPauseButtonPressed():
	$spawnMenuPosition.show()
	get_tree().paused = true
	var menuInstanced = pauseMenuScene.instance()
	$spawnMenuPosition.add_child(menuInstanced)
	menuInstanced.connect("canHide", self, "canHideMenu")
	
func canHideMenu():
	$spawnMenuPosition.hide()

func onDificultyIncreased():
	if key == true:
		increaseGlucoseDecreasedValue += 0.5
		increaseFruitValue += 0.5
		print("Valor de Incremento da glicemia auxiliar: ", increaseFruitValue)
		print("Valor de Decremento da glicemia auxiliar: ", increaseGlucoseDecreasedValue)
		if increaseGlucoseDecreasedValue >= 10:
			key = false
			$dificultyTimer.stop()
	if keyAux == true:
		spawnIncreaserValue += 0.1
		print("Valor de Spawn auxiliar: ", spawnIncreaserValue)
		if spawnIncreaserValue >= 0.7:
			keyAux = false

func onExerciseLabelPressed():
	ProjectManager.quizResult.glucoseAmout = str(glucoseCalculus)
	ProjectManager.quizResult.totalScore = pointsCount
	ProjectManager.save()
	fadeAnimation.play("blinkScreen")
	yield(get_tree().create_timer(0.7), "timeout")
	ProjectManager.quizResult.gameOverHyper = true
	ProjectManager.save()
	_changeScene = get_tree().change_scene("res://Scenes/girlScenes/girlGameOver.tscn")
