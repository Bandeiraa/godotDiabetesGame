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
var glucoseCalculus = 70
var candiesCount = 0
var pointsCount = 0
var randomGlucoseValue; var storeValue = 0
var aux = 0; var aux2 = 0
var _changeScene; var isOutside = false

func spawnFruit():
	fruitsTimer.start()
	randomize()
	var randomTimerIndex = rand_range(0.3, 1.5)
	#print("RANDOM FRUIT SPAWN VALUE: ", randomTimerIndex)
	fruitsTimer.set_wait_time(randomTimerIndex)
	var fruit = respawnFruit(FRUITS).instance()
	fruitPosition = Vector2()
	fruitPosition.x = rand_range(-58, 58)
	fruit.set_position(fruitPosition)
	$FruitPosition.add_child(fruit)
	fruit.connect("fruitDestroyed", self, "canIncreasePointsCount")
		
func spawnCandie():
	candiesTimer.start()
	randomize()
	var randomTimerIndex = rand_range(1.5, 3.0)
	#print("RANDOM CANDIE SPAWN VALUE: ", randomTimerIndex)
	candiesTimer.set_wait_time(randomTimerIndex)
	var candie = respawnCandie(CANDIES).instance()
	candiePosition = Vector2()
	candiePosition.x = rand_range(-58, 58)
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
	aux2 = int(rand_range(5, 20))
	storeValue += aux2
	glucoseCalculus = glucoseCalculus + storeValue
	glucoseValue.text = str(glucoseCalculus)
	pointsCount += 20
	if pointsCount < 10:
		$layer/pointsCountLabel.text = str("000", pointsCount)
	elif pointsCount < 100:
		$layer/pointsCountLabel.text = str("00", pointsCount)
	elif pointsCount < 1000:
		$layer/pointsCountLabel.text = str("0", pointsCount)
	else:
		$layer/pointsCountLabel.text = str(pointsCount)
	storeValue = 0
		
func canIncreaseGlucose():
	candiesCount += 1
	
	if candiesCount >= 1 && candiesCount <= 5:
		glucoseCalculus = 70 + (candiesCount * 16)
		glucoseValue.text = str(glucoseCalculus)
	elif candiesCount >= 6 && candiesCount <= 10:
		glucoseCalculus = 162 + ((candiesCount - 6) * 7)
		glucoseValue.text = str(glucoseCalculus)
	elif candiesCount >= 11 && candiesCount <= 26:
		glucoseCalculus = 189 + ((candiesCount - 10) * 7)
		glucoseValue.text = str(glucoseCalculus)
	else:
		print("Hperglicemia até demais, se cuide")

func onGlucoseTimerTimeout():
	randomize()
	randomGlucoseValue = int(rand_range(5, 15))
	aux += randomGlucoseValue #+ glucoseCalculus
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
		ProjectManager.quizResult.glucoseAmout = str(glucoseCalculus)
		ProjectManager.quizResult.totalScore = pointsCount
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
