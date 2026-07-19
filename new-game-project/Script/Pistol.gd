extends Node3D
var kick_timer: float = 0.0
@onready var ray := $"1911/RayCast3D"
@onready var bullet_trail: MeshInstance3D = $"1911/BulletTrail"
@onready var laser_trail: MeshInstance3D = $"1911/Laser Trail"
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("kick"):
		kick_timer = 1.67
	if kick_timer > 0.0:
		kick_timer -= delta
	var can_aim: bool = kick_timer <= 0.0
	if can_aim:
		visible = Input.is_action_pressed("aim")
	else:
		visible = false
	update_laser_sight()
func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("shoot") and Input.is_action_pressed("aim"):
		shoot()
func shoot() -> void:
	ray.global_rotation.x = 0
	var end_point: Vector3
	if ray.is_colliding():
		var hit: Node = ray.get_collider()
		end_point = ray.get_collision_point()
		if hit.is_in_group("zombie"):
			hit.take_damage(2)
		elif hit.get_parent().is_in_group("zombie"):
			hit.get_parent().take_damage(2)
	else:
		end_point = $AimRayEnd.global_position
	create_bullet_trail($Barrel.global_position, end_point)
func create_bullet_trail(start: Vector3, end: Vector3) -> void:
	var immediate_mesh := ImmediateMesh.new()
	var material := StandardMaterial3D.new()
	material.albedo_color = Color(1, 1, 0.6)
	material.emission_enabled = true
	material.emission = Color(1, 1, 0.6)
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	bullet_trail.mesh = immediate_mesh
	bullet_trail.material_override = material
	bullet_trail.visible = true
	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES)
	immediate_mesh.surface_add_vertex(bullet_trail.to_local(start))
	immediate_mesh.surface_add_vertex(bullet_trail.to_local(end))
	immediate_mesh.surface_end()
	var timer := get_tree().create_timer(0.05)
	timer.timeout.connect(func(): bullet_trail.visible = false)
func update_laser_sight() -> void:
	if not visible:
		laser_trail.visible = false
		return
	ray.global_rotation.x = 0
	var end_point: Vector3
	if ray.is_colliding():
		end_point = ray.get_collision_point()
	else:
		end_point = $AimRayEnd.global_position
	var start_point: Vector3 = $Laser.global_position
	var immediate_mesh := ImmediateMesh.new()
	var material := StandardMaterial3D.new()
	material.albedo_color = Color(1, 0, 0)
	material.emission_enabled = true
	material.emission = Color(1, 0, 0)
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	laser_trail.mesh = immediate_mesh
	laser_trail.material_override = material
	laser_trail.visible = true
	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES)
	immediate_mesh.surface_add_vertex(laser_trail.to_local(start_point))
	immediate_mesh.surface_add_vertex(laser_trail.to_local(end_point))
	immediate_mesh.surface_end()
