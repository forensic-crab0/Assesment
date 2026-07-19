extends Node3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var player: CharacterBody3D = $"../.."
func _ready() -> void:
	var anim: Animation = animation_player.get_animation("mixamo_com")
	anim.loop_mode = Animation.LOOP_LINEAR
	animation_player.play("mixamo_com")
func _process(_delta: float) -> void:
	var is_moving: bool = player.velocity.length() > 0.1
	var pressing_forward: bool = Input.is_action_pressed("front")
	var pressing_back: bool = Input.is_action_pressed("back")
	var is_turning: bool = Input.is_action_pressed("left") or Input.is_action_pressed("right")
	var is_sprinting: bool = Input.is_action_pressed("run")
	var is_aiming: bool = Input.is_action_pressed("aim")
	visible = (is_moving and pressing_forward and player.velocity.length() < 5 or (is_turning and not pressing_back and (not is_sprinting or not is_moving))) and not is_aiming
