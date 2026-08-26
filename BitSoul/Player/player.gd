extends CharacterBody2D

# State Machine
enum {
	MOVE
}

const SPEED = 200.0
const JUMP_VELOCITY = -400.0

# int, var
@onready var anim = $AnimatedSprite2D
@onready var animPlayer = $AnimationPlayer
@onready var animPlDeath = $"../../Death_Player/CanvasLayer/AnimationPlayer"
var health = 100
var diamond = 0
var state = MOVE
var key_collected = false
var is_hurt = false

func _ready():
	Global.player = self

# Physics
func _physics_process(delta: float) -> void:
	match state:
		MOVE:
			move_state()
	
	# Gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Jump
	if Input.is_action_just_pressed("Up") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		animPlayer.play("Jump")
		
	# Fall
	if velocity.y > 0:
		animPlayer.play("Fall")
		
	# Death
	if health <= 0:
		health = 0
		animPlayer.play("Death")
		await get_tree().create_timer(1.5).timeout
		$"../../Death_Player/CanvasLayer".visible = true
		animPlDeath.play("player_death")
		velocity = Vector2.ZERO
		set_physics_process(false)

# End
	move_and_slide()

# Left, Right
func move_state ():
	var direction := Input.get_axis("Left", "Right")
	if direction:
		velocity.x = direction * SPEED
		if velocity.y == 0:
			animPlayer.play("Run")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if velocity.y == 0:
			animPlayer.play("idle")
			
	if direction == -1:
		anim.flip_h = true
		
	elif direction == 1:
		anim.flip_h = false
	
func has_key() -> bool:
	return key_collected

func take_damage(amount: int, knockback_dir := Vector2.ZERO):
	if is_hurt or health <= 0:
		return

	health -= amount
	is_hurt = true

	if knockback_dir != Vector2.ZERO:
		velocity = knockback_dir.normalized() * 200

	var tween = get_tree().create_tween()
	tween.set_loops(3)
	tween.tween_property(anim, "modulate", Color(1, 1, 1, 0), 0.1)
	tween.tween_property(anim, "modulate", Color(1, 1, 1), 0.1)
	await get_tree().create_timer(1.0).timeout
	is_hurt = false
