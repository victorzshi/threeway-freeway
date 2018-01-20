extends RigidBody2D

export var rotation_speed = 3
export var MAX_VELOCITY = 300
export var burst = 500
export var friction = 0.65

var rotation = 0
var screen = Vector2()
var position = Vector2()
var velocity = Vector2()
var acceleration = Vector2()

func _ready():

	screen = get_viewport_rect().size

	set_fixed_process(true)

func _fixed_process(delta):

	if Input.is_action_pressed("ui_left"):
		rotation += rotation_speed * delta
	if Input.is_action_pressed("ui_right"):
		rotation -= rotation_speed * delta
	if Input.is_action_pressed("ui_up"):
		acceleration = Vector2(burst, 0).rotated(rotation)
	else:
		acceleration = Vector2(0,0)
		velocity = velocity * friction 
		if(Input.is_action_pressed("ui_down")):
			acceleration = Vector2(burst, 0).rotated(rotation) * -1

	acceleration += velocity * delta
	velocity += acceleration * delta
	position += velocity * delta
	# vehicle can't go out of bounds
	if(position.x >= screen.width):
		position.x = screen.width
	if(position.x <= 0):
		position.x = 0
	if(position.y >= screen.height):
		position.y = screen.height
# Let the ship flyyyyy
#	if(position.y <= 0):
#		position.y = 0

	
	set_pos(position)
	set_rot(rotation - PI/2)
