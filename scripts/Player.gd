extends KinematicBody2D

export (PackedScene) var bullet
onready var bullet_container = get_node("bullet_container")
onready var gun_cd = get_node("gun_cd")

const MOVE_SPEED = 500

var velocity = Vector2()
var rotation = PI/2
var acceleration = Vector2()

var is_moving
signal move

export var rotation_speed = 3
export var MAX_VELOCITY = 1000
export var burst = 500
export var friction = 0.95

var timer

var left_player_role
var middle_player_role
var right_player_role

func _fixed_process(delta):
	
	if right_player_role == 'turning':
		if Input.is_action_pressed("right_turn_left"):
			rotation += rotation_speed * delta
		if Input.is_action_pressed("right_turn_right"):
			rotation -= rotation_speed * delta
	elif right_player_role == 'accelerating':
		if Input.is_action_pressed("right_accelerate"):
			acceleration = Vector2(burst, 0).rotated(rotation)
			is_moving = true
		else:
			acceleration = Vector2(0,0)
			velocity = velocity * friction 
			if(Input.is_action_pressed("right_reverse")):
				acceleration = Vector2(burst, 0).rotated(rotation) * -1
				is_moving = true
	elif right_player_role == 'shooting':
		if gun_cd.get_time_left() == 0:
			if Input.is_action_pressed("right_shoot_forward"):
				shoot_forward()
			if Input.is_action_pressed("right_shoot_right"):
				shoot_right()
			if Input.is_action_pressed("right_shoot_left"):
				shoot_left()

	if middle_player_role == 'turning':
		if Input.is_action_pressed("middle_turn_left"):
			rotation += rotation_speed * delta
		if Input.is_action_pressed("middle_turn_right"):
			rotation -= rotation_speed * delta
	elif middle_player_role == 'accelerating':
		if Input.is_action_pressed("middle_accelerate"):
			acceleration = Vector2(burst, 0).rotated(rotation)
			is_moving = true
		else:
			acceleration = Vector2(0,0)
			velocity = velocity * friction 
			if(Input.is_action_pressed("middle_reverse")):
				acceleration = Vector2(burst, 0).rotated(rotation) * -1
				is_moving = true
	elif middle_player_role == 'shooting':
		if gun_cd.get_time_left() == 0:
			if Input.is_action_pressed("middle_shoot_forward"):
				shoot_forward()
			if Input.is_action_pressed("middle_shoot_right"):
				shoot_right()
			if Input.is_action_pressed("middle_shoot_left"):
				shoot_left()

	if left_player_role == 'turning':
		if Input.is_action_pressed("left_turn_left"):
			rotation += rotation_speed * delta
		if Input.is_action_pressed("left_turn_right"):
			rotation -= rotation_speed * delta
	elif left_player_role == 'accelerating':
		if Input.is_action_pressed("left_accelerate"):
			acceleration = Vector2(burst, 0).rotated(rotation)
			is_moving = true
		else:
			acceleration = Vector2(0,0)
			velocity = velocity * friction 
			if(Input.is_action_pressed("left_reverse")):
				acceleration = Vector2(burst, 0).rotated(rotation) * -1
				is_moving = true
	elif left_player_role == 'shooting':
		if gun_cd.get_time_left() == 0:
			if Input.is_action_pressed("leftt_shoot_forward"):
				shoot_forward()
			if Input.is_action_pressed("left_shoot_right"):
				shoot_right()
			if Input.is_action_pressed("left_shoot_left"):
				shoot_left()

	acceleration += velocity * delta
	velocity += acceleration * delta
	if velocity.y <= -MAX_VELOCITY:
		velocity.y = -MAX_VELOCITY

	var motion = velocity * delta
	motion = move(motion)
		
	if is_moving:
		emit_signal("move")
	set_rot(rotation - PI/2)

	if (is_colliding()):
		var n = get_collision_normal()
		motion = n.slide(motion)
		velocity = n.slide(velocity)
		move(motion)
	
	is_moving = false

func _ready():
	set_fixed_process(true)

func shoot_forward():
	gun_cd.start()
	var shot = bullet.instance()
	bullet_container.add_child(shot)
	shot.start(get_rot(), get_node("front").get_global_pos())

func shoot_right():
	gun_cd.start()
	var shot = bullet.instance()
	bullet_container.add_child(shot)
	shot.start(get_rot() - PI/2, get_node("right").get_global_pos())

func shoot_left():
	gun_cd.start()
	var shot = bullet.instance()
	bullet_container.add_child(shot)
	shot.start(get_rot() + PI/2, get_node("left").get_global_pos())

func role_switch_handler(state1, state2, state3):
	print("switch " + state1 + state2 + state3)
	left_player_role = state1
	middle_player_role = state2
	right_player_role = state3
