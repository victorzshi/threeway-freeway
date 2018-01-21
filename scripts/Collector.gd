extends Area2D

onready var ship_explosion = preload("res://scenes/ShipExplosion.tscn")
onready var crate_explosion = preload("res://scenes/CrateExplosion.tscn")
onready var death_sound = get_node("death_sound")

# Screen shake variables
onready var camera = get_tree().get_root().get_node("Map/Player/Camera2D")
var magnitude = 60
var duration = 1.5
var time = 0

func _ready():
	connect("body_enter", self, "_on_object_enter")	
	
func _on_object_enter(body):
	print(body, " touched the wall...")
	if body.is_in_group("player"):
		print("GAME OVER")
		
		# Hide ship and show explosion
		body.hide()
		death_sound.play("death")
		
		shake()
		var explode = ship_explosion.instance()
		explode.set_global_pos(body.get_global_pos())
		explode.set_emitting(true)
		get_node("../../").add_child(explode)
		
		global.last_score = global.current_distance
		
		var t = Timer.new()
		t.set_wait_time(3)
		t.set_one_shot(true)
		self.add_child(t)
		t.start()
		yield(t, "timeout")
		
		#death_sound.play("lose")
		get_tree().change_scene("res://scenes/Menu.tscn")
		
	elif body.is_in_group("obstacle") or body.is_in_group("obs_destruct"):
		
		var explode = crate_explosion.instance()
		death_sound.play("block")
		explode.set_global_pos(body.get_global_pos())
		explode.set_emitting(true)
		get_node("../../").add_child(explode)
		body.free()

func shake():
	while time < duration:
		time += get_process_delta_time()
		
		var offset = Vector2()
		randomize()
		offset.x = rand_range(-magnitude, magnitude)
		offset.y = rand_range(-magnitude, magnitude)
		camera.set_offset(offset)
		
		yield(get_tree(), "idle_frame")
	time = 0