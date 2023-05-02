extends CharacterBody2D

@onready var anim = $AnimatedSprite2D
@onready var machine = $Machine

###########################################################
# enter tree

func _enter_tree():
	Hotel.book(self)

###########################################################
# ready

func _ready():
	Hotel.register(self)
	machine.start()

func hotel_data():
	return {}

func check_out(_data):
	pass

###########################################################
