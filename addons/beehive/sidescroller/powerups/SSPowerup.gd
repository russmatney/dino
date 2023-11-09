extends Node2D

##############################################################
# powerup enum

@export var powerup: SS.Powerup :
	set(v):
		powerup = v
		if anim:
			match (powerup):
				SS.Powerup.Sword: anim.play("sword")
				SS.Powerup.DoubleJump: anim.play("doublejump")
				SS.Powerup.Climb: anim.play("climbinggloves")
				_: anim.play("read")

##############################################################
# nodes

@onready var action_area = $ActionArea
@onready var anim = $AnimatedSprite2D

##############################################################
# ready

var picked_up = false

func _ready():
	Hotel.register(self)
	action_area.register_actions(actions, {source=self})

##############################################################
# hotel

func check_out(data):
	picked_up = data.get("picked_up", picked_up)
	powerup = data.get("powerup", powerup)

func hotel_data():
	return {powerup=powerup, picked_up=picked_up, position=position}

##############################################################
# actions

var actions = [
	Action.mk({
		label="Pick Up", fn=pickup,
		source_can_execute=func(): return not picked_up,
		show_on_source=true, show_on_actor=false,}),
	Action.mk({
		label="Read", fn=read_note,
		source_can_execute=func(): return picked_up,
		show_on_source=true, show_on_actor=false,}),
	]

func pickup(player):
	DJZ.play(DJZ.S.collectpowerup)
	player.add_powerup(powerup)
	picked_up = true
	Hotel.check_in(self)
	show_jumbotron(player)

func read_note(player):
	DJZ.play(DJZ.S.showjumbotron)
	show_jumbotron(player)

func show_jumbotron(player):
	var header
	var body
	var action
	var label
	match (powerup):
		SS.Powerup.Sword:
			header = "[jump]Sword[/jump]\nDiscovered!"
			body = "Try it on wooden blocks!"
			action = "attack"
			label = "Swing"
		SS.Powerup.DoubleJump:
			header = "[jump]Double Jump[/jump]\nDiscovered!"
			body = "....but how?"
			action = "jump"
			label = "Jump"
		SS.Powerup.Climb:
			header = "[jump]Climbing Gloves[/jump]\nDiscovered!"
			body = "Hold towards a wall to grab it."
			action = "ad"
			label = "Toward wall"

	if header:
		player.force_move_to_target(global_position)
		Q.jumbo_notif({
			header=header, body=body, action=action, action_label_text=label,
			on_close=player.clear_forced_move_target})
