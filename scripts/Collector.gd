extends Area2D

onready var root_camera = get_tree().get_root().get_node("Map/Camera2D")

func _ready():
	connect("body_enter", self, "_on_object_enter")	
	
func _on_object_enter(body):
	print(body, " touched the wall...")
	if body.is_in_group("player"):
		print("GAME OVER")
		global.last_score = global.current_distance
		get_tree().change_scene("res://scenes/Menu.tscn")
	elif body.is_in_group("obstacle"):
		body.free()