extends StreamPlayer

signal start_game

var beat_interval = 60.0/127.0
var timer = 0
var beat = 0

func _ready():
	connect("start_game", self, "role_switch_handler")
	set_process(true)
	pass

func _process(delta):
	pass
	
func start_game_handler():
	self.play()