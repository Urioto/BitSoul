extends CharacterBody2D

@onready var anim = $AnimatedSprite2D
@onready var animPlayer = $AnimationPlayer
@export var move_range := 50.0
var chase = false
var speed = 60
var alive = true
var just_killed = false
var is_hiding = false
var direction := -1
var start_x := 0.0

func _ready() -> void:
	start_x = global_position.x

func _physics_process(delta: float) -> void:
	if not alive or is_hiding:
		velocity.x = 0
		move_and_slide()
		return

	if not is_on_floor():
		velocity += get_gravity() * delta

	if chase:
		var player = Global.player
		if player:
			var dir = (player.global_position - global_position).normalized()
			velocity.x = dir.x * speed
			animPlayer.play("Run")
			
			anim.flip_h = dir.x < 0
		else:
			chase = false
	else:
		velocity.x = direction * speed
		animPlayer.play("Idle")

		if global_position.x < start_x - move_range and direction < 0:
			direction = 1
			anim.flip_h = false
		elif global_position.x > start_x + move_range and direction > 0:
			direction = -1
			anim.flip_h = true

	move_and_slide()

func _on_detector_body_entered(body: Node2D) -> void:
	if body.name == "Player" and alive and not is_hiding:
		is_hiding = true
		velocity = Vector2.ZERO
		animPlayer.play("Hide")


func _on_detector_body_exited(body: Node2D) -> void:
	if body.name == "Player" and alive and is_hiding:
		is_hiding = false
		animPlayer.play("Idle")


func _on_death_body_entered(body: Node2D) -> void:
	if body.name == "Player" and alive and not is_hiding:
		body.velocity.y = 300
		just_killed = true
		death()

func death():
	alive = false
	animPlayer.play("Death")
	await animPlayer.animation_finished
	queue_free()
