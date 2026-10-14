extends Node2D

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Sceens/game_world.tscn")

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
