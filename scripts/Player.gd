extends KinematicBody2D

const MOVE_SPEED = 200

var velocity = Vector2()

func _fixed_process(delta):
	velocity.y = 0
	if (Input.is_action_pressed("ui_left")):
		velocity.x = - MOVE_SPEED
	elif (Input.is_action_pressed("ui_right")):
		velocity.x =   MOVE_SPEED
	else:
		velocity.x = 0

	var motion = velocity * delta
	motion = move(motion)

	if (is_colliding()):
		var n = get_collision_normal()
		motion = n.slide(motion)
		velocity = n.slide(velocity)
		move(motion)

func _ready():
	set_fixed_process(true)
