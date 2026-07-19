extends MeshInstance3D

@onready var mesh_instance: MeshInstance3D = $MeshInstance3D
@onready var timer: Timer = $Timer

func setup(start: Vector3, end: Vector3) -> void:
	var distance := start.distance_to(end)
	global_position = start
	look_at(end, Vector3.UP)
	mesh_instance.scale.z = distance
	mesh_instance.position.z = -distance / 2.0
	timer.start()

func _on_timer_timeout() -> void:
	queue_free()
