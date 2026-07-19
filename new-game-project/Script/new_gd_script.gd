extends CharacterBody3D
@export var turn_speed: float = 180.0
@export var walk_speed: float = 3.0
@export var run_speed: float = 15.0
const NORMAL_LENGTH = 4.0
const AIM_LENGTH = -0.47
const ZOOM_SPEED = 8.0
@onready var cam_yaw := $CamRoot/CamYaw
@onready var visual := $"Player Model"
@onready var spring_arm := $CamRoot/CamYaw/CamPitch/SpringArm3D
var kick_lock_timer: float = 0.0
func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	if Input.is_action_just_pressed("kick"):
		kick_lock_timer = 1.65
	if kick_lock_timer > 0.0:
		kick_lock_timer -= delta
		velocity.x = move_toward(velocity.x, 0, walk_speed)
		velocity.z = move_toward(velocity.z, 0, walk_speed)
		move_and_slide()
		return
	var is_aiming := Input.is_action_pressed("aim") and kick_lock_timer <= 0.0
	var target_length := AIM_LENGTH if is_aiming else NORMAL_LENGTH
	spring_arm.spring_length = lerp(spring_arm.spring_length, target_length, ZOOM_SPEED * delta) as float
	if is_aiming:
		velocity.x = 0
		velocity.z = 0
		var cam_basis: Basis = cam_yaw.global_transform.basis
		var cam_angle := atan2(-cam_basis.z.x, -cam_basis.z.z)
		visual.rotation.y = cam_angle
	else:
		var moving = Input.is_action_pressed("front") or Input.is_action_pressed("back")
		if moving:
			if Input.is_action_pressed("run") and not Input.is_action_pressed("back"):
				handle_run(delta)
			else:
				handle_walk(delta)
			handle_turn(delta)
		else:
			velocity.x = move_toward(velocity.x, 0, walk_speed)
			velocity.z = move_toward(velocity.z, 0, walk_speed)
	move_and_slide()
func handle_turn(delta: float) -> void:
	var turn_direction = Input.get_axis("left", "right")
	visual.rotation_degrees.y -= turn_direction * turn_speed * delta
func handle_walk(delta: float) -> void:
	var input_direction = Input.get_axis("front", "back")
	var walk_velocity = -visual.basis.z * input_direction * walk_speed
	velocity.x = walk_velocity.x
	velocity.z = walk_velocity.z
func handle_run(delta: float) -> void:
	var input_direction = Input.get_axis("front", "back")
	var run_velocity = -visual.basis.z * input_direction * run_speed
	velocity.x = run_velocity.x
	velocity.z = run_velocity.z
