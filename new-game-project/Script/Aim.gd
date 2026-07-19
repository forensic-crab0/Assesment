extends Node3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready():
	var anim = animation_player.get_animation("mixamo_com")
	anim.loop_mode = Animation.LOOP_LINEAR
	animation_player.play("mixamo_com")

func _process(_delta: float) -> void:
	visible = Input.is_action_pressed("aim")
