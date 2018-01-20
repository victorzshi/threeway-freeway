extends KinematicBody2D

var SPEED = 3

func _fixed_process(delta):
    move( Vector2(0, -SPEED) )

func _ready():
    set_fixed_process(true)