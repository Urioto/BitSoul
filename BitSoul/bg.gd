extends ParallaxBackground

var speed = 1

func _process(delta: float) -> void:
	scroll_offset.x -= speed + delta
