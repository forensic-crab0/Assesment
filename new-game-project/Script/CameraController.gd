
extends Node

@onready var yaw_node = $CamYaw
@onready var pitch_node = $CamYaw/CamPitch

var yaw: float = 0.0
var pitch: float = 0.0

var yaw_sensitivity: float = 0.50
var pitch_sensitivity: float = 0.50

var yaw_acceleration: float = 15.0
var pitch_acceleration: float = 15.0

var pitch_max: float = 75.0
var pitch_min: float = -55.0

# Recoil stuff
var recoil_amount: float = 3.0
var recoil_recovery: float = 8.0
var recoil_offset: float = 0.0

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		yaw += -event.relative.x * yaw_sensitivity
		pitch += -event.relative.y * pitch_sensitivity

func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("aim") and Input.is_action_just_pressed("shoot"):
		recoil_offset += recoil_amount

	recoil_offset = lerp(recoil_offset, 0.0, recoil_recovery * delta)

	var target_pitch = pitch - recoil_offset
	target_pitch = clamp(target_pitch, pitch_min, pitch_max)

	yaw_node.rotation_degrees.y = lerp(
		yaw_node.rotation_degrees.y,
		yaw,
		yaw_acceleration * delta
	)

	pitch_node.rotation_degrees.x = lerp(
		pitch_node.rotation_degrees.x,
		target_pitch,
		pitch_acceleration * delta
	)
