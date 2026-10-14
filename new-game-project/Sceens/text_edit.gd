extends TextEdit

var elapsed_time: float = 0.0

func _ready() -> void:
	editable = false

func _process(delta: float) -> void:
	elapsed_time += delta

	var minutes = int(elapsed_time) / 60
	var seconds = int(elapsed_time) % 60

	text = "%02d:%02d" % [minutes, seconds]
