extends CharacterBody2D

@onready var anim = $AnimatedSprite2D
@onready var machine = $Machine
@onready var aa = $ActionArea

###########################################################
# enter tree

func _enter_tree():
	Hotel.book(self)

###########################################################
# ready

func _ready():
	Hotel.register(self)
	machine.start()
	Cam.add_offscreen_indicator(self)

	aa.register_actions(actions, self)

func hotel_data():
	return {}

func check_out(_data):
	pass

###########################################################

var actions = [
	Action.mk({
		label="Call",
		fn=call_from_player,
		})
	]

func call_from_player(player):
	Debug.pr("call from player", player)
