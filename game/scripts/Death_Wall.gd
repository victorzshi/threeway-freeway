extends KinematicBody2D

var SPEED = 2
var MIN_DISTANCE = 600
var DEATH_DISTANCE = 15400 #offset 400 for initial player spawn
onready var player = get_node("../Player")

func _fixed_process(delta):
	var player_pos = player.get_global_pos()
	if abs(player_pos.y - self.get_global_pos().y) > MIN_DISTANCE:
		move(Vector2(0, -SPEED * 8))
	elif -player_pos.y > DEATH_DISTANCE:
		move(Vector2(0, -SPEED * 2))
	else:
		move(Vector2(0, -SPEED))

func _ready():
	set_fixed_process(true)