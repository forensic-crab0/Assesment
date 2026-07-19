extends Node3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var player: CharacterBody3D = $"../.."
var kick_timer: float = 0.0
func _ready():
	var anim = animation_player.get_animation("mixamo_com")
	anim.loop_mode = Animation.LOOP_LINEAR
	animation_player.play("mixamo_com")
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("kick"):
		kick_timer = 1.67
	if kick_timer > 0.0:
		kick_timer -= delta
		visible = false
	else:
		visible = player.velocity.length() < 0.1 and not Input.is_action_pressed("aim")
