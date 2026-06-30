extends CharacterBody3D
const SPEED = 5.0
const AIM_SPEED = 2.0
const NORMAL_LENGTH = 3.0
const AIM_LENGTH = -0.1
const ZOOM_SPEED = 8.0
@onready var cam_yaw := $CamRoot/CamYaw
@onready var visual := $"Player Model"
@onready var spring_arm := $CamRoot/CamYaw/CamPitch/SpringArm3D
func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	var is_aiming := Input.is_action_pressed("aim")

	# Zoom camera in/out smoothly
	var target_length := AIM_LENGTH if is_aiming else NORMAL_LENGTH
	spring_arm.spring_length = lerp(spring_arm.spring_length, target_length, ZOOM_SPEED * delta) as float

	if is_aiming:
		var cam_basis: Basis = cam_yaw.global_transform.basis
		var forward: Vector3 = -cam_basis.z
		var right: Vector3 = cam_basis.x
		forward.y = 0.0
		right.y = 0.0
		forward = forward.normalized()
		right = right.normalized()
		var input_dir := Input.get_vector("left", "right", "front", "back")
		var direction: Vector3 = (right * input_dir.x + forward * -input_dir.y)
		if direction.length() > 0:
			velocity.x = direction.x * AIM_SPEED
			velocity.z = direction.z * AIM_SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, AIM_SPEED)
			velocity.z = move_toward(velocity.z, 0, AIM_SPEED)
		
		var cam_angle := atan2(-cam_basis.z.x, -cam_basis.z.z)
		visual.rotation.y = cam_angle
	else:
		var input_dir := Input.get_vector("left", "right", "front", "back")
		var cam_basis: Basis = cam_yaw.global_transform.basis
		var forward: Vector3 = -cam_basis.z
		var right: Vector3 = cam_basis.x
		forward.y = 0.0
		right.y = 0.0
		forward = forward.normalized()
		right = right.normalized()
		var direction: Vector3 = (right * input_dir.x + forward * -input_dir.y).normalized()
		if direction:
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
			var target_angle := atan2(direction.x, direction.z)
			visual.rotation.y = lerp_angle(visual.rotation.y, target_angle, 0.15)
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)
	move_and_slide()
