extends TextEdit

func _ready() -> void:
	editable = false

func _process(delta: float) -> void:
	text = "Score: " + str(Score.total)


	if Score.total >= 400:
		get_tree().change_scene_to_file("res://Sceens/you_won.tscn")
