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
	Hotel.register(self)
	action_area.register_actions(actions, self)

##############################################################
# hotel

func check_out(data):
	picked_up = data.get("picked_up", picked_up)
	powerup = data.get("powerup", powerup)

func hotel_data():
	return {powerup=powerup, picked_up=picked_up}

##############################################################
# actions

var actions = [
	Action.mk({
		label="Pick Up", fn=pickup,
		source_can_execute=func(): return not picked_up}),
	Action.mk({
		label="Read", fn=read_note,
		source_can_execute=func(): return picked_up}),
	]

func pickup():
	MvaniaGame.player.add_powerup(powerup)
	picked_up = true
	Hotel.check_in(self)
	show_jumbotron()

func read_note():
	show_jumbotron()

func show_jumbotron():
	var header
	var body
	var action
	var label
	match (powerup):
		MvaniaGame.Powerup.Sword:
			header = "[jump]Sword[/jump]\nDiscovered!"
			body = "Try it on wooden blocks!"
			action = "attack"
			label = "Swing"
		MvaniaGame.Powerup.DoubleJump:
			header = "[jump]Double Jump[/jump]\nDiscovered!"
			body = "....but how?"
			action = "jump"
			label = "Jump"
		MvaniaGame.Powerup.Climb:
			header = "[jump]Climbing Gloves[/jump]\nDiscovered!"
			body = "Hold towards a wall to grab it."
			action = "ad"
			label = "Toward wall"

	if header:
		MvaniaGame.set_forced_movement_target(global_position)
		var on_close = Hood.jumbo_notif(header, body, action, label)
		if on_close:
			on_close.connect(MvaniaGame.clear_forced_movement_target)