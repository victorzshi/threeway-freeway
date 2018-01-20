extends CanvasLayer

signal role_switch

var distance = 0
var difference  = 0

var role_textures = {
	"turning": [
		preload("res://assets/player1_turn.png"),
		preload("res://assets/player2_turn.png"),
		preload("res://assets/player3_turn.png"),
	],
	"shooting": [
		preload("res://assets/player1_shoot.png"),
		preload("res://assets/player2_shoot.png"),
		preload("res://assets/player3_shoot.png"),
	],
	"accelerating": [
		preload("res://assets/player1_accelerate.png"),
		preload("res://assets/player2_accelerate.png"),
		preload("res://assets/player3_accelerate.png"),
	]
}

var role_texts = {
	"turning": 		"Turning",
	"accelerating": "Speed",
	"shooting": 	"Shooting"
}

func _ready():
	set_process(true)
	get_node("SwitchLabel").show_prompt("Switch!")
	connect("role_switch", self, "role_switch_handler")
	
	for i in range(3):
		get_node("RoleImage" + str(i)).set_scale(Vector2(200.0/940, 200.0/940))
	
	role_switch_handler("turning", "accelerating", "shooting")

func _process(delta):
	# TODO update distance
	get_node("DistanceLabel").set_text("" + "m")
	# TODO update difference
	get_node("DifferenceLabel").set_text("-" + "m")	
	pass
	
func role_switch_handler(role_0, role_1, role_2):
	var roles = [role_0, role_1, role_2]
	for i in range(3):
		get_node("RoleLabel" + str(i)).set_text(role_texts[roles[i]])
		get_node("RoleImage" + str(i)).set_texture(role_textures[roles[i]][i])