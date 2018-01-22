extends Camera2D

var screen_width = Globals.get("display/width")
onready var player_pos = get_node("../").get_global_pos()

func ready():
	var new_pos = Vector2(screen_width / 2, player_pos.y)
	set_global_pos(new_pos)

func _process(delta):
	player_pos = get_node("Player").get_global_pos()
	var new_pos = Vector2(screen_width / 2, player_pos.y)
	set_global_pos(new_pos)
