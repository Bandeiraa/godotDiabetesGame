extends Area2D

export var velocity = Vector2()
signal candyDestroied

func _ready():
	set_process(true)
	pass
	
func _process(delta):
	translate(velocity * delta)
	self.rotate(0.05)
	
	if get_position().y >= get_viewport_rect().size.y - 20:
		queue_free()

func onCandyInputEvent(_viewport, event, _shapeidx):
	if (event is InputEventMouseButton && event.pressed):
		print("Candy Clicked D:")
		emit_signal("candyDestroied")
		queue_free()
