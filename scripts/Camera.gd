extends Camera2D

var screen_width = Globals.get("display/width")
onready var player = get_node("../")

func ready():
	var player_pos = player.get_global_pos()
	var new_pos = Vector2(screen_width / 2, player_pos.y)
	set_global_pos(new_pos)

func update_camera():
	var player_pos = player.get_global_pos()
	var new_pos = Vector2(screen_width / 2, player_pos.y)
	set_global_pos(new_pos)
