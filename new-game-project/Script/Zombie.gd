extends CharacterBody3D

const SPEED = 1.0
const GRAVITY = 9.8
const MAX_HEALTH = 3

var health := MAX_HEALTH
var is_dead := false

@onready var nav_agent := $NavigationAgent3D
@onready var player := $"../Player 3D"
@onready var anim := $"Zombie Rig/Armature/AnimationPlayer"

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= GRAVITY * delta

	if is_dead:
		velocity.x = 0
		velocity.z = 0
		move_and_slide()
		return

	if player == null:
		return

	nav_agent.target_position = player.global_position

	var next_point: Vector3 = nav_agent.get_next_path_position()
	var direction: Vector3 = (next_point - global_position).normalized()
	direction.y = 0.0

	if direction.length() > 0:
		var target_angle := atan2(direction.x, direction.z)
		rotation.y = lerp_angle(rotation.y, target_angle, 0.15)
		anim.play("Walk")
	else:
		anim.play("Idle")

	velocity.x = direction.x * SPEED
	velocity.z = direction.z * SPEED

	move_and_slide()

func take_damage(amount: int) -> void:
	health -= amount
	print("Zombie health: ", health)
	if health <= 0:
		die()

func die() -> void:
	is_dead = true
	queue_free()
