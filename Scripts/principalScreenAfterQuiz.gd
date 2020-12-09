extends Control

onready var Animator = get_node("Animator")

func _ready():
	ProjectManager.loadData()
	$totalPoints.text = ProjectManager.quizResult.totalPoints
	$correctAnswers.text = str(ProjectManager.quizResult.correctAnswers)
	$wrongAnswers.text = str(ProjectManager.quizResult.wrongAnswers)

func onGearPressed():
	Animator.play("gearAnimation")
	yield(get_tree().create_timer(0.5), "timeout")
	$Menu.set_visible(true)

func onBackButtonPressed():
	$Menu.set_visible(false)
	
