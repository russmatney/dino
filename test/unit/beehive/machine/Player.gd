extends KinematicBody2D


var velocity := Vector2.ZERO

export(int) var jump_impulse := 1000
export(int) var speed := 500
export(int) var gravity := 2000

var initial_pos

func _ready():
    initial_pos = get_global_position()

func _process(_delta):
    if get_global_position().y > 30000:
        position = initial_pos
        velocity = Vector2.ZERO
