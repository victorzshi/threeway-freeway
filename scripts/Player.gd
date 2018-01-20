extends KinematicBody2D

export (PackedScene) var bullet
onready var bullet_container = get_node("bullet_container")
onready var gun_cd = get_node("gun_cd")

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