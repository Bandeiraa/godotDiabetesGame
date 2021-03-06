extends Node2D

var FRUITS = [preload("res://Scenes/FoodsScenes/FruitScene/Banana.tscn"), preload("res://Scenes/FoodsScenes/FruitScene/BellPepper.tscn"), preload("res://Scenes/FoodsScenes/FruitScene/Carrot.tscn"), preload("res://Scenes/FoodsScenes/FruitScene/Eggplant.tscn"),
			  preload("res://Scenes/FoodsScenes/FruitScene/Pear.tscn"), preload("res://Scenes/FoodsScenes/FruitScene/Lettuce.tscn"), preload("res://Scenes/FoodsScenes/FruitScene/Orange.tscn"), preload("res://Scenes/FoodsScenes/FruitScene/Strawberry.tscn"),
			  preload("res://Scenes/FoodsScenes/FruitScene/Tomatoe.tscn")]
			
var CANDIES = [preload("res://Scenes/FoodsScenes/CandieScene/Brigadeiro.tscn"), preload("res://Scenes/FoodsScenes/CandieScene/Cake.tscn"), preload("res://Scenes/FoodsScenes/CandieScene/Chocolate.tscn"),
			   preload("res://Scenes/FoodsScenes/CandieScene/Cookie.tscn"), preload("res://Scenes/FoodsScenes/CandieScene/FrenchFries.tscn"), preload("res://Scenes/FoodsScenes/CandieScene/Sandwich.tscn"),
			   preload("res://Scenes/FoodsScenes/CandieScene/Sugar.tscn")]
			
onready var glucoseValue = $Layer/GlucoseLabel
onready var fruitPosition = get_node("FruitPosition")
onready var candiePosition = get_node("CandiePosition")
onready var fruitsTimer = $FruitsTimer
onready var candiesTimer = $CandiesTimer
onready var blinkAnim = $Animator
onready var warningAnimator = $WarningAnimator

signal savePoints
var glucoseKey = false
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
	ProjectManager.loadData()
	if ProjectManager.quizResult.increaseFruitValue == 10:
		pass
	else:
		$DificultyTimer.start()
	pauseMenuScene = preload("res://Scenes/EndScenes/Menu/Girl/Menu.tscn")
	if increaseGlucoseDecreasedValue == 10:
		$DificultyTimer.stop()
	
func onBackToScene():
	ProjectManager.loadData()
	print("Bonus = ", ProjectManager.quizResult.bonus)
	hasInternetConection = ProjectManager.quizResult.hasInternet
	print(hasInternetConection)
	storedPointsValue = int(ProjectManager.quizResult.totalScore)
	$Layer/PointsCountLabel.text = str(storedPointsValue)
	storedGlucoseValue = str(ProjectManager.quizResult.glucoseAmount)
	glucoseCalculus = int(storedGlucoseValue)
	glucoseValue.text = str(glucoseCalculus)
	candiesCount = int(ProjectManager.quizResult.candiesCount)
	print(candiesCount)
	print(ProjectManager.quizResult.bonus)
	spawnIncreaserValue = ProjectManager.quizResult.increasedSpawn
	increaseGlucoseDecreasedValue = ProjectManager.quizResult.increasedGlucoseAmount
	increaseFruitValue = ProjectManager.quizResult.increaseFruitValue
	sum = storedPointsValue
	if ProjectManager.quizResult.bonus == 1:
		$SceneComponents/BonusButton.set_visible(true)
	else:
		$SceneComponents/BonusButton.set_visible(false)

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
		$Layer/PointsCountLabel.text = str(sum)
	elif canFreezeGlucose == true:
		pointsCount += 20
		sum = pointsCount + storedPointsValue
		$Layer/PointsCountLabel.text = str(sum)
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
		$Layer/ExerciseSpriteAux.set_visible(false)
		blinkAnim.play("blinkWarningExercise")
		isOutside = true
	else:
		$Layer/ExerciseSpriteAux.set_visible(true)
		if isOutside == true:
			$Animator.seek(0)
			isOutside = false
		
	if glucoseCalculus >= 190:
		$GlucoseTimer.stop()
		$HyperglycemiaPopup.show()
	else:
		$HyperglycemiaPopup.hide()
		
	if(glucoseCalculus >= 30 && glucoseCalculus <= 70):
		warningAnimator.play("warningLabel")
		$WarningMessage.set_visible(true)
		blinkAnim.play("blinkWarning")
	elif glucoseCalculus <= 30 and glucoseKey == false:
		emit_signal("savePoints")
		glucoseKey = true
		
	else:
		$WarningMessage.set_visible(false)
		
func onDNothingButtonPressed():
	PopupButton.play()
	ProjectManager.quizResult.glucoseAmout = str(glucoseCalculus)
	ProjectManager.quizResult.totalScore = pointsCount
	ProjectManager.quizResult.gameOverDoNothing = true
	ProjectManager.save()
	BlinkAnimation.canPlay()
	yield(get_tree().create_timer(0.7), "timeout")
	_changeScene = get_tree().change_scene("res://Scenes/EndScenes/GameOver/Girl/GameOver.tscn")
	
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
		PopupButton.play()
		var storeScenePath = str("res://Scenes/EndScenes/Exercise/Girl/Exercise", str(randomExercise), ".tscn")
		_changeScene = get_tree().change_scene(storeScenePath)

func onInsulinButtonPressed():
	PopupButton.play()
	ProjectManager.quizResult.glucoseAmount = str(glucoseCalculus)
	ProjectManager.quizResult.totalScore = sum
	ProjectManager.quizResult.candiesCount = candiesCount
	ProjectManager.quizResult.increasedSpawn = spawnIncreaserValue 
	ProjectManager.quizResult.increaseFruitValue = increaseFruitValue
	ProjectManager.quizResult.increasedGlucoseAmount = increaseGlucoseDecreasedValue
	ProjectManager.save()
	_changeScene = get_tree().change_scene("res://Scenes/EndScenes/Insulin/Girl/Insulin.tscn")

func onBonusPressed():
	PopupButton.play()
	$GlucoseTimer.stop()
	$BonusTimer.start()
	canFreezeGlucose = true
	$SceneComponents/BonusButton.set_visible(false)
	ProjectManager.quizResult.bonus = 0
	ProjectManager.save()

func onBonusEnd():
	$GlucoseTimer.start()
	canFreezeGlucose = false

func onPauseButtonPressed():
	ConfigPopup.play()
	yield(get_tree().create_timer(0.3), "timeout")
	$SpawnMenuPosition.show()
	get_tree().paused = true
	var menuInstanced = pauseMenuScene.instance()
	$SpawnMenuPosition.add_child(menuInstanced)
	menuInstanced.connect("canHide", self, "canHideMenu")
	
func canHideMenu():
	$SpawnMenuPosition.hide()

func onDificultyIncreased():
	if key == true:
		increaseGlucoseDecreasedValue += 0.5
		increaseFruitValue += 0.5
		print("Valor de Incremento da glicemia auxiliar: ", increaseFruitValue)
		print("Valor de Decremento da glicemia auxiliar: ", increaseGlucoseDecreasedValue)
		if increaseGlucoseDecreasedValue == 10:
			key = false
			$DificultyTimer.stop()
		if keyAux == true and spawnIncreaserValue <= 0.5:
			spawnIncreaserValue += 0.1
			print("Valor de Spawn auxiliar: ", spawnIncreaserValue)
			if spawnIncreaserValue == 0.5:
				keyAux = false

func onExerciseLabelPressed():
	PopupButton.play()
	ProjectManager.quizResult.glucoseAmout = str(glucoseCalculus)
	ProjectManager.quizResult.totalScore = pointsCount
	ProjectManager.save()
	BlinkAnimation.canPlay()
	yield(get_tree().create_timer(0.7), "timeout")
	ProjectManager.quizResult.gameOverHyper = true
	ProjectManager.save()
	_changeScene = get_tree().change_scene("res://Scenes/EndScenes/GameOver/Girl/GameOver.tscn")

func onSavePoints():
	ProjectManager.quizResult.glucoseAmount = str(glucoseCalculus)
	ProjectManager.quizResult.totalScore = str(sum)
	ProjectManager.quizResult.gameOverHypo = true
	ProjectManager.save()
	BlinkAnimation.canPlay()
	yield(get_tree().create_timer(0.7), "timeout")
	_changeScene = get_tree().change_scene("res://Scenes/EndScenes/GameOver/Girl/GameOver.tscn")
