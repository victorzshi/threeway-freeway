extends Area2D

var velocity = Vector2()
export var speed = 1000

func _ready():
	set_fixed_process(true)
	
	get_node("CollisionShape2D").connect("body_enter", self, "collision_handler")

func start(direction, position):
	set_rot(direction)
	set_pos(position)
	velocity = Vector2(speed, 0).rotated(direction + PI/2)

func _fixed_process(delta):

	set_pos(get_pos() + velocity * delta)

func destroy():
	pass

func collision_handler(body):
	print (body)
