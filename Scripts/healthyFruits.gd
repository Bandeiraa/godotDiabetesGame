extends Area2D

export var velocity = Vector2()
signal fruitDestroyed

func _ready():
	set_process(true)
	pass
	
func _process(delta):
	translate(velocity * delta)
	self.rotate(0.05)
	
	if get_position().y >= get_viewport_rect().size.y - 20:
		queue_free()

func onFruitInputEvent(_viewport, event, _shapeidx):
	if (event is InputEventMouseButton && event.pressed):
		print("Fruit Consumed :D")
		emit_signal("fruitDestroyed")
		queue_free()
