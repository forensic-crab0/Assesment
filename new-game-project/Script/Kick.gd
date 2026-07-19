extends Node3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	visible = false
	animation_player.animation_finished.connect(_on_animation_finished)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("kick") and not visible:
		visible = true
		animation_player.play("mixamo_com")

func _on_animation_finished(anim_name: String) -> void:
	visible = false
