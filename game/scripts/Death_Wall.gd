extends KinematicBody2D

var SPEED = 2
var MIN_DISTANCE = 600
onready var player = get_node("../Player")

func _fixed_process(delta):
	if abs(player.get_global_pos().y - self.get_global_pos().y) > MIN_DISTANCE:
		move(Vector2(0, -SPEED * 8))
	else:
		move(Vector2(0, -SPEED))

func _ready():
	set_fixed_process(true)