extends Area2D

onready var ship_explosion = preload("res://scenes/ShipExplosion.tscn")
onready var crate_explosion = preload("res://scenes/CrateExplosion.tscn")

func _ready():
	connect("body_enter", self, "_on_object_enter")	
	
func _on_object_enter(body):
	print(body, " touched the wall...")
	if body.is_in_group("player"):
		print("GAME OVER")
		
		# Hide ship and show explosion
		body.hide()
		var explode = ship_explosion.instance()
		explode.set_global_pos(body.get_global_pos())
		explode.set_emitting(true)
		get_node("../../").add_child(explode)
		
		global.last_score = global.current_distance
		
		var t = Timer.new()
		t.set_wait_time(1)
		t.set_one_shot(true)
		self.add_child(t)
		t.start()
		yield(t, "timeout")
		
		get_tree().change_scene("res://scenes/Menu.tscn")
		
	elif body.is_in_group("obstacle") or body.is_in_group("obs_destruct"):
		
		var explode = crate_explosion.instance()
		explode.set_global_pos(body.get_global_pos())
		explode.set_emitting(true)
		get_node("../../").add_child(explode)
		body.free()