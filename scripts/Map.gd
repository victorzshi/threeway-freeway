extends Node2D

# Game parameters
var obstacle_interval = 1000 # Higher is easier
var difficulty_scale = 0.8 # Lower is harder
var level_1 = 10000
var level_2 = 20000
var level_3 = 30000
var level_4 = 40000
var level_5 = 50000

# References
var screen_size = Vector2(Globals.get("display/width"), Globals.get("display/height"))
var obstacle1 = preload("res://scenes/Obstacle1.tscn")
var last_pos
var camera_pos
var top_of_screen
var bottom_of_screen
	
# Nodes
onready var player = get_node("Player")
onready var camera = get_node("Player/Camera2D")
onready var back1 = get_node("Background1")
onready var back2 = get_node("Background2")

func _ready():

	# Debug
	print("X: ", screen_size.x, " Y:", screen_size.y)
	print("Camera pos: ", camera.get_global_pos())
	print("Player pos: ", player.get_global_pos())
	
	# Set initial player position for obstacle generation
	last_pos = player.get_global_pos()
	
	# Set initial camera position
#	camera_pos = camera.get_global_pos()
	top_of_screen = last_pos.y - (screen_size.y / 2)
	bottom_of_screen = last_pos.y + (screen_size.y / 2)

	set_process(true)

func _process(delta):
	
	# Current camera and screen positions
	
	camera_pos = player.get_global_pos()
	top_of_screen = camera_pos.y - (screen_size.y / 2)
	bottom_of_screen = camera_pos.y + (screen_size.y / 2)
	
	# Generate infinite road background image
	
	var back1_pos = back1.get_pos()
	var back2_pos = back2.get_pos()
	
	var back1_height = back1.get_texture().get_height()
	
	if back1_pos.y > bottom_of_screen:
		print("Moving Background1")
		back1_pos.y = back1_pos.y - (2 * back1_height)
	if back2_pos.y > bottom_of_screen:
		print("Moving Background2")
		back2_pos.y = back2_pos.y - (2 * back1_height)
		
	get_node("Background1").set_pos(back1_pos)
	get_node("Background2").set_pos(back2_pos)
	
	# Generate obstacles based on distance of player
	# Use function to generate pre-loaded instance of obstacle (check nuts and bolts) 
	# at a random x-coord along screen dimensions
	# Also make it possible generate more than one obstacle along same line on y axis
	
	var current_pos = player.get_global_pos()
	
	if current_pos.y > -level_1:
		if (last_pos.y - current_pos.y > obstacle_interval):
			# Generate new obstacle
			generate_obstacles(1, "unbreakable")
			# Set last_pos to current_pos
			last_pos = current_pos
	elif current_pos.y > -level_2:
		if (last_pos.y - current_pos.y > obstacle_interval * difficulty_scale):
			# Generate new obstacle
			generate_obstacles(1, "unbreakable")
			# Set last_pos to current_pos
			last_pos = current_pos
	elif current_pos.y > -level_3:
		if (last_pos.y - current_pos.y > obstacle_interval * difficulty_scale):
			# Generate new obstacle
			generate_obstacles(2, "unbreakable")
			# Set last_pos to current_pos
			last_pos = current_pos
	elif current_pos.y > -level_4:
		if (last_pos.y - current_pos.y > obstacle_interval * pow(difficulty_scale, 2)):
			# Generate new obstacle
			generate_obstacles(2, "unbreakable")
			# Set last_pos to current_pos
			last_pos = current_pos
	elif current_pos.y > -level_5:
		if (last_pos.y - current_pos.y > obstacle_interval * pow(difficulty_scale, 2)):
			# Generate new obstacle
			generate_obstacles(3, "unbreakable")
			# Set last_pos to current_pos
			last_pos = current_pos
	else:
		if (last_pos.y - current_pos.y > obstacle_interval * pow(difficulty_scale, 3)):
			# Generate new obstacle
			generate_obstacles(3, "unbreakable")
			# Set last_pos to current_pos
			last_pos = current_pos
		
	
	# Once player moves enough distance from last save position, generate again
	
func generate_obstacles(num, type):
	# Type should be unbreakable or breakable
	for i in range(num):
		var obstacle = obstacle1.instance()
		randomize()
		obstacle.set_pos(Vector2(screen_size.x * randf(), top_of_screen - 100))
		add_child(obstacle)