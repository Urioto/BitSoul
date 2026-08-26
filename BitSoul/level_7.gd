extends Node2D

@onready var animPlayer = $CanvasLayer/AnimationPlayer
@onready var door = $Buildings/Door
@onready var key = $Collectibles/Key
@onready var player = $Player2/Player
@onready var anim_player_exit = $Exit/CanvasLayer/AnimationPlayer
@onready var screen_effect = $ScreenEffect

enum {
	LOADING,
	PLAYING,
	ENDING
}

var state = LOADING

func _ready() -> void:
	door.connect("body_entered", Callable(self, "_on_body_entered"))
	key.connect("picked_up", Callable(self, "_on_key_picked_up"))
	lvl_text_fade()

func _physics_process(_delta):
	match state:
		LOADING:
			pass
		PLAYING:
			pass
		ENDING:
			pass
	
func _input(event):
	if event.is_action_pressed("Esc") and state == PLAYING:
		$Main/MainMenu/Panel.visible = not $Main/MainMenu/Panel.visible
	
func lvl_text_fade ():
	state = LOADING
	animPlayer.play("lvl_text_fade_in")
	await get_tree().create_timer(3).timeout
	animPlayer.play("lvl_text_fade_out")
	state = PLAYING
	
func _on_key_picked_up():
	player.key_collected = true
	
func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://level_menu.tscn")
	
func _on_door_door_opened() -> void:
	if state == PLAYING:
		state = ENDING
		await get_tree().create_timer(1.0).timeout
		$Exit/CanvasLayer.visible = true
		anim_player_exit.play("level_complete")
		await anim_player_exit.animation_finished
		get_tree().change_scene_to_file("res://level_menu.tscn")

func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	get_tree().reload_current_scene()

func _on_invert_pressed() -> void:
	if screen_effect.material is ShaderMaterial:
		$ScreenEffect.visible = true
		var mat = screen_effect.material as ShaderMaterial
		var current = mat.get_shader_parameter("invert")
		mat.set_shader_parameter("invert", not current)
