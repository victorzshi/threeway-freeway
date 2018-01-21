extends Area2D

var velocity = Vector2()
export var speed = 1000
var timer

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
	queue_free()

func _on_object_enter(body):
	if body.is_in_group("obs_destruct"):
		# play explosion
		body.free()
		self.queue_free()
	elif body.is_in_group("obstacle"):
		self.queue_free()