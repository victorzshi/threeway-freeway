extends Area2D

func _ready():
	connect("body_enter", self, "_on_object_enter")	
	
func _on_object_enter(body):
	print(body, " touched the wall...")
	if body.is_in_group("player"):
		print("GAME OVER")
		body.free()
	elif body.is_in_group("obstacle"):
		body.free()