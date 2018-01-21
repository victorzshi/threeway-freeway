extends Area2D

func _ready():
	connect("body_enter", self, "_on_object_enter")	
	
func _on_object_enter(body):
	print(body, " touched the wall...")
	if body.is_in_group("player"):
		print("GAME OVER")
		global.last_score = global.current_distance
		get_tree().change_scene("res://scenes/Menu.tscn")
	elif body.is_in_group("obstacle") or body.is_in_group("obs_destruct"):
		body.free()