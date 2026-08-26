extends CharacterBody2D

@onready var anim = $AnimatedSprite2D
@onready var animPlayer = $AnimationPlayer
@export var speed := 100
@export var max_chase_distance := 300.0
@export var patrol_distance := 50.0
var chase = false
var alive = true
var just_killed = false
var start_position: Vector2
var moving_right = true

func _ready() -> void:
	start_position = global_position

func _physics_process(_delta: float) -> void:
	# Add the gravity.
	if not alive:
		return
	
	var player = Global.player
	if player == null:
		return
	
	var distance_to_player = global_position.distance_to(player.global_position)

	if distance_to_player <= max_chase_distance and chase:
		var direction = (player.global_position - global_position).normalized()
		velocity = direction * speed
		animPlayer.play("Run")
		anim.flip_h = direction.x < 0

	else:
		var target_x = start_position.x + (patrol_distance if moving_right else -patrol_distance)
		var direction = Vector2(1 if moving_right else -1, 0)
		velocity = direction * speed
		animPlayer.play("Run")
		anim.flip_h = moving_right == false

		if moving_right and global_position.x >= target_x:
			moving_right = false
		elif not moving_right and global_position.x <= target_x:
			moving_right = true

	move_and_slide()

func _on_detector_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		chase = true


func _on_detector_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		chase = false


func _on_death_body_entered(body: Node2D) -> void:
	if body.name == "Player" and alive:
		if body.global_position.y < global_position.y:
			body.velocity.y = 300
			just_killed = true
			death()


func _on_death_2_body_entered(body: Node2D) -> void:
	if body.name == "Player" and alive and not just_killed:
		if alive == true:
			if "take_damage" in body:
				var knockback_dir = global_position.direction_to(body.global_position)
				body.take_damage(40, knockback_dir)
			else:
				body.health -= 40
		death()

func death ():
	alive = false
	animPlayer.play("Death")
	await animPlayer.animation_finished
	queue_free()
