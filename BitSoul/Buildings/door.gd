extends Area2D

signal door_opened

@onready var animPlayer = $AnimationPlayer
var is_opened := false

func _ready() -> void:
	pass

func _on_body_entered(body: Node2D) -> void:
	if body.name != "Player" or is_opened:
		return
	if body.has_method("has_key") and body.has_key():
		is_opened = true
		animPlayer.play("Open")
		await animPlayer.animation_finished
		emit_signal("door_opened")
	else:
		animPlayer.play("Idle")
