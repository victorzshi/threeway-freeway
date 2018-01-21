extends Area2D

var velocity = Vector2()
export var speed = 1000
var timer
onready var crate_explosion = preload("res://scenes/CrateExplosion.tscn")

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
		var explode = crate_explosion.instance()
		explode.set_global_pos(body.get_global_pos())
		explode.set_emitting(true)
		get_tree().get_root().add_child(explode)
		body.free()
		destroy()
	elif body.is_in_group("obstacle"):
		destroy()