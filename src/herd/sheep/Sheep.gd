extends CharacterBody2D

@onready var anim = $AnimatedSprite2D
@onready var machine = $Machine
@onready var aa = $ActionArea
@onready var action_hint = $ActionHint

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

	aa.register_actions(actions, {source=self, action_hint=action_hint})

func hotel_data():
	return {}

func check_out(_data):
	pass

###########################################################

var actions = [
	Action.mk({
		label_fn=func(): return str("Call ", name),
		fn=call_from_player,
		source_can_execute=func(): return target == null,
		})
	]

var target

func call_from_player(player):
	Debug.pr(name, "call from player", player)

	machine.transit("Follow", {target=player})
