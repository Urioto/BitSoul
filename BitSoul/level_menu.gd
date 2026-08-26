extends Node2D


func _ready() -> void:
	pass


func _on_exitmenu_pressed() -> void:
	get_tree().change_scene_to_file("res://menu.tscn")


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://level.tscn")


func _on_button_2_pressed() -> void:
	get_tree().change_scene_to_file("res://level_2.tscn")


func _on_button_3_pressed() -> void:
	get_tree().change_scene_to_file("res://level_3.tscn")


func _on_button_4_pressed() -> void:
	get_tree().change_scene_to_file("res://level_4.tscn")


func _on_button_5_pressed() -> void:
	get_tree().change_scene_to_file("res://level_5.tscn")


func _on_button_6_pressed() -> void:
	get_tree().change_scene_to_file("res://level_6.tscn")


func _on_button_7_pressed() -> void:
	get_tree().change_scene_to_file("res://level_7.tscn")


func _on_button_8_pressed() -> void:
	get_tree().change_scene_to_file("res://level_8.tscn")
