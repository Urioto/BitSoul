extends Area2D

@onready var animPlayer = $AnimationPlayer
@onready var help_label = $BannerText2/Label
var has_been_viewed = false

func _ready() -> void:
	help_label.visible = false
	animPlayer.play("Move")

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		help_label.visible = true
	if not has_been_viewed:
			animPlayer.play("Idle")
			has_been_viewed = true

func _on_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		help_label.visible = false
