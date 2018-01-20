extends Node2D

# Game parameters
var obstacle_interval = 1000 # Higher is easier
var difficulty_scale = 0.5 # Lower is harder
var level_1 = 200
var level_2 = 300
var level_3 = 400
var level_4 = 500
var level_5 = 600

# Nodes
onready var player = get_node("Player")
onready var back1 = get_node("Background1")
onready var back2 = get_node("Background2")

# References
var screen_size = Vector2(Globals.get("display/width"), Globals.get("display/height"))
var obstacle1 = preload("res://scenes/Obstacle1.tscn")
var player_pos
var last_pos
var initial_pos
var top_of_screen
var bottom_of_screen
	
# Initialization
onready var back1_pos = back1.get_pos()
onready var back2_pos = back2.get_pos()
onready var back1_height = back1.get_texture().get_height()
	
func _ready():
	var rhythm_node = get_node("RhythmManager")
	rhythm_node.connect("role_switch", self, "role_switch_handler")
	rhythm_node.connect("beat", self, "beat_handler")
	
	global.current_distance = 0
	global.distance_from_line = 0
	
	# Debug
	print("X: ", screen_size.x, " Y:", screen_size.y)
	print("Player pos: ", player.get_global_pos())
	
	# Set initial player position for obstacle generation
	player_pos = player.get_global_pos()
	top_of_screen = player_pos.y - (screen_size.y / 2)
	bottom_of_screen = player_pos.y + (screen_size.y / 2)
	last_pos = player_pos
	initial_pos = player_pos
	
	set_process(true)

func _process(delta):
	global.current_distance = abs(player_pos.y - initial_pos.y)
	global.distance_from_line = abs(player_pos.y - get_node("Death Wall").get_global_pos().y)

func role_switch_handler(r1, r2, r3):
	get_node("HUD").role_switch_handler(r1, r2, r3)
	get_node("Player").role_switch_handler(r1, r2, r3)

func beat_handler(beat_cnt):
	get_node("HUD").beat_handler(beat_cnt)

func generate_obstacles(num, type):
	# Type should be unbreakable or breakable
	for i in range(num):
		var obstacle = obstacle1.instance()
		randomize()
		obstacle.set_pos(Vector2(screen_size.x * randf(), top_of_screen - 100))
		add_child(obstacle)

func _on_Player_move():
	print("Player is moving...")
	player_pos = player.get_global_pos()
	
	# Current camera and screen positions
	top_of_screen = player_pos.y - (screen_size.y / 2)
	bottom_of_screen = player_pos.y + (screen_size.y / 2)
	
	# Generate infinite road background image
	if back1_pos.y > bottom_of_screen + back1_height / 2:
		print("Moving Background1")
		back1_pos.y = back1_pos.y - (2 * back1_height)
	if back2_pos.y > bottom_of_screen + back1_height / 2:
		print("Moving Background2")
		back2_pos.y = back2_pos.y - (2 * back1_height)
		
	get_node("Background1").set_pos(back1_pos)
	get_node("Background2").set_pos(back2_pos)
	
	# Generate obstacles based on distance of player
	# Use function to generate pre-loaded instance of obstacle
	# at a random x-coord along screen dimensions
	
	var current_pos = player_pos
	
	if current_pos.y > -level_1:
		if (last_pos.y - current_pos.y > obstacle_interval):
			# Generate new obstacle
			generate_obstacles(3, "unbreakable")
			# Set last_pos to current_pos
			last_pos = current_pos
	elif current_pos.y > -level_2:
		if (last_pos.y - current_pos.y > obstacle_interval * difficulty_scale):
			# Generate new obstacle
			generate_obstacles(3, "unbreakable")
			# Set last_pos to current_pos
			last_pos = current_pos
	elif current_pos.y > -level_3:
		if (last_pos.y - current_pos.y > obstacle_interval * difficulty_scale):
			# Generate new obstacle
			generate_obstacles(4, "unbreakable")
			# Set last_pos to current_pos
			last_pos = current_pos
	elif current_pos.y > -level_4:
		if (last_pos.y - current_pos.y > obstacle_interval * pow(difficulty_scale, 2)):
			# Generate new obstacle
			generate_obstacles(5, "unbreakable")
			# Set last_pos to current_pos
			last_pos = current_pos
	elif current_pos.y > -level_5:
		if (last_pos.y - current_pos.y > obstacle_interval * pow(difficulty_scale, 2)):
			# Generate new obstacle
			generate_obstacles(6, "unbreakable")
			# Set last_pos to current_pos
			last_pos = current_pos
	else:
		if (last_pos.y - current_pos.y > obstacle_interval * pow(difficulty_scale, 3)):
			# Generate new obstacle
			generate_obstacles(7, "unbreakable")
			# Set last_pos to current_pos
			last_pos = current_pos
