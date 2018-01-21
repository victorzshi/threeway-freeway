extends CanvasLayer

func _ready():
	if global.last_score != 0:
		get_node("TitleScoreLabel").set_text(str(global.last_score) + "m")
	else:
		get_node("TitleScoreLabel").set_text("Threeway Freeway")
		
	set_process(true)

func _process(delta):
	if Input.is_action_pressed("ui_accept"):
		get_tree().change_scene("res://scenes/Map.tscn")