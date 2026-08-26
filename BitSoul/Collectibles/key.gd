extends Area2D

signal picked_up

var floating_tween: Tween

func _ready() -> void:
	start_floating()
	
func start_floating():
	floating_tween = get_tree().create_tween()
	floating_tween.set_loops(-1)
	var up = position - Vector2(0, 3)
	var down = position + Vector2(0, 3)
	floating_tween.tween_property(self, "position", up, 1.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	floating_tween.tween_property(self, "position", down, 1.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

func _on_body_entered(body) -> void:
	if body.name == "Player":
		if floating_tween:
			floating_tween.kill()
		var tween = get_tree().create_tween()
		var tween1 = get_tree().create_tween()
		tween.tween_property(self, "position", position - Vector2(0, 25), 0.3)
		tween1.tween_property(self, "modulate:a", 0, 0.3)
		tween.tween_callback(Callable(self, "queue_free"))
		emit_signal("picked_up")
