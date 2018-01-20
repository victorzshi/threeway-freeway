extends Label

var fade_speed = 2

func _ready():
	set_text("")
	set_process(true)

func _process(delta):
	var opacity = get_self_opacity()
	if opacity > 0:
		set_self_opacity(opacity - delta*fade_speed)

func show_prompt(text):
	set_text(text)
	set_self_opacity(1)
	pass
