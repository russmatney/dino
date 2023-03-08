extends Node2D

##############################################################
# powerup enum

@export var powerup: MvaniaGame.Powerup :
	set(v):
		powerup = v
		if anim:
			match (powerup):
				MvaniaGame.Powerup.Sword: anim.play("sword")
				MvaniaGame.Powerup.DoubleJump: anim.play("double_jump")
				MvaniaGame.Powerup.Climb: anim.play("climb")

##############################################################
# nodes

@onready var action_area = $ActionArea
@onready var anim = $AnimatedSprite2D

##############################################################
# ready

var picked_up = false

func _ready():
	restore()
	Hotel.check_in(self)
	action_area.register_actions(actions, self)

##############################################################
# hotel

func restore():
	var _data = Hotel.check_out(self)

func hotel_data():
	return {powerup=powerup, picked_up=picked_up}

##############################################################
# actions

var actions = [
	Action.mk({
		label="Pick Up", fn=pickup,
		source_can_execute=func(): return not picked_up}),
	]

func pickup():
	MvaniaGame.player.add_powerup(powerup)
	picked_up = true
	Hotel.check_in(self)

	# TODO tween out
	queue_free()

