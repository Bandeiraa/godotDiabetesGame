extends Node2D

onready var blinkAnimation = get_node("BlinkAnimator")

func canPlay():
	blinkAnimation.play("BlinkAnimation")
	
func canGearPlay():
	$GearSprite.show()
	blinkAnimation.play("GearAnimation")
	yield(get_tree().create_timer(0.9), "timeout")
	$GearSprite.hide()
	
func canGearGirlPlay():
	$GearGirlSprite.show()
	blinkAnimation.play("GearAnimation")
	yield(get_tree().create_timer(0.9), "timeout")
	$GearGirlSprite.hide()

