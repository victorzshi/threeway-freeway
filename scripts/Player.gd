extends KinematicBody2D

const MOVE_SPEED = 500

var velocity = Vector2()
var rotation = 0
var acceleration

export var rotation_speed = 3
export var MAX_VELOCITY = 1000
export var burst = 500
export var friction = 0.65

var timer

var left_player_role
var middle_player_role
var right_player_role

func set_state(state):
	if state == 1:
		left_player_role = 'turning'
		middle_player_role = 'accelerating'
		right_player_role = 'shooting'
	elif state == 2:
		left_player_role = 'turning'
		middle_player_role = 'shooting'
		right_player_role = 'accelerating'
	elif state == 3:
		left_player_role = 'accelerating'
		middle_player_role = 'shooting'
		right_player_role = 'turning'
	elif state == 4:
		left_player_role = 'accelerating'
		middle_player_role = 'turning'
		right_player_role = 'shooting'
	elif state == 5:
		left_player_role = 'shooting'
		middle_player_role = 'turning'
		right_player_role = 'accelerating'
	elif state == 6:
		left_player_role = 'shooting'
		middle_player_role = 'accelerating'
		right_player_role = 'turning'
	else:
		left_player_role = 'turning'
		middle_player_role = 'accelerating'
		right_player_role = 'shooting'
	
	print(left_player_role)

func randomize_state():
	set_state(randi()%7+1)
	timer.set_wait_time(rand_range(5.0, 20.0))
	timer.start()

func _fixed_process(delta):
	if right_player_role == 'turning':
		if Input.is_action_pressed("right_turn_left"):
			rotation += rotation_speed * delta
		if Input.is_action_pressed("right_turn_right"):
			rotation -= rotation_speed * delta
	elif right_player_role == 'accelerating':
		if Input.is_action_pressed("right_accelerate"):
			acceleration = Vector2(burst, 0).rotated(rotation)
		else:
			acceleration = Vector2(0,0)
			velocity = velocity * friction 
			if(Input.is_action_pressed("right_reverse")):
				acceleration = Vector2(burst, 0).rotated(rotation) * -1

	if middle_player_role == 'turning':
		if Input.is_action_pressed("middle_turn_left"):
			rotation += rotation_speed * delta
		if Input.is_action_pressed("middle_turn_right"):
			rotation -= rotation_speed * delta
	elif middle_player_role == 'accelerating':
		if Input.is_action_pressed("middle_accelerate"):
			acceleration = Vector2(burst, 0).rotated(rotation)
		else:
			acceleration = Vector2(0,0)
			velocity = velocity * friction 
			if(Input.is_action_pressed("middle_reverse")):
				acceleration = Vector2(burst, 0).rotated(rotation) * -1

	if left_player_role == 'turning':
		if Input.is_action_pressed("left_turn_left"):
			rotation += rotation_speed * delta
		if Input.is_action_pressed("left_turn_right"):
			rotation -= rotation_speed * delta
	elif left_player_role == 'accelerating':
		if Input.is_action_pressed("left_accelerate"):
			acceleration = Vector2(burst, 0).rotated(rotation)
		else:
			acceleration = Vector2(0,0)
			velocity = velocity * friction 
			if(Input.is_action_pressed("left_reverse")):
				acceleration = Vector2(burst, 0).rotated(rotation) * -1

	acceleration += velocity * delta
	velocity += acceleration * delta
	if velocity.y <= -MAX_VELOCITY:
		velocity.y = -MAX_VELOCITY

	var motion = velocity * delta
	motion = move(motion)
	set_rot(rotation - PI/2)

	if (is_colliding()):
		var n = get_collision_normal()
		motion = n.slide(motion)
		velocity = n.slide(velocity)
		move(motion)

func _ready():
	randomize()
	set_state(-1)
	timer = get_node("Timer")
	timer.set_wait_time(20.0)
	timer.connect("timeout", self, "randomize_state")
	
	set_fixed_process(true)
	
	timer.start()
	set_fixed_process(true)
