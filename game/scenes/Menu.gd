extends CanvasLayer

onready var start = get_node("start")

func _ready():
	if global.last_score != -1:
		get_node("TitleScoreLabel").set_text(str(round(global.last_score)) + "m")
	else:
		get_node("TitleScoreLabel").set_text("Threeway Freeway")
		
	set_process(true)

func _process(delta):
	if Input.is_action_pressed("ui_accept"):
		start.play("start")
		get_tree().change_scene("res://scenes/Map.tscn")