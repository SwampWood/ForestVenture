extends ParallaxBackground


var velocity = 1


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	scroll_offset.x -= velocity + delta
