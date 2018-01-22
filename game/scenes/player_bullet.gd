extends Area2D

var velocity = Vector2()
export var speed = 1000
var timer
onready var crate_explosion = preload("res://scenes/CrateExplosion.tscn")

# Screen shake variables
onready var camera = get_tree().get_root().get_node("Map/Player/Camera2D")
var magnitude = 13
var duration = 1
var time = 0

func _ready():
	set_fixed_process(true)
	connect("body_enter", self, "_on_object_enter")
	timer = get_node("Timer")
	timer.set_wait_time(10)
	timer.start()
	timer.connect("timeout", self, "destroy")
	
func start(direction, position):
	set_rot(direction)
	set_pos(position)
	velocity = Vector2(speed, 0).rotated(direction + PI/2)

func _fixed_process(delta):
	set_pos(get_pos() + velocity * delta)

func destroy():
	get_node("destroy").set_emitting(true)
	self.queue_free()

func _on_object_enter(body):
	if body.is_in_group("obs_destruct"):
		# play explosion
		shake()
		var explode = crate_explosion.instance()
		explode.set_global_pos(body.get_global_pos())
		explode.set_emitting(true)
		get_tree().get_root().add_child(explode)
		body.free()
		destroy()
	elif body.is_in_group("obstacle"):
		destroy()

func shake():
	while time < duration:
		time += get_process_delta_time()
		
		var offset = Vector2()
		randomize()
		offset.x = rand_range(-magnitude, magnitude)
		#offset.y = rand_range(-magnitude, magnitude)
		camera.set_offset(offset)
		
		yield(get_tree(), "idle_frame")
	time = 0
