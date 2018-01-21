extends Particles2D

var timer

func _ready():
	timer = get_node("Timer")
	timer.set_wait_time(2)
	timer.start()
	timer.connect("timeout", self, "destroy")

func destroy():
	self.queue_free()
