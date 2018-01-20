extends Area2D

var velocity = Vector2()
export var speed = 1000

func _ready():
	set_fixed_process(true)

func start(direction, position):
	set_rot(direction)
	set_pos(position)
	velocity = Vector2(speed, 0).rotated(direction + PI/2)

func _fixed_process(delta):
	set_pos(get_pos() + velocity * delta)
