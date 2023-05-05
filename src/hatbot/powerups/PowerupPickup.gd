extends Node2D

##############################################################
# powerup enum

@export var powerup: HatBot.Powerup :
	set(v):
		powerup = v
		if anim:
			match (powerup):
				HatBot.Powerup.Sword: anim.play("sword")
				HatBot.Powerup.DoubleJump: anim.play("doublejump")
				HatBot.Powerup.Climb: anim.play("climbinggloves")
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
		HatBot.Powerup.Sword:
			header = "[jump]Sword[/jump]\nDiscovered!"
			body = "Try it on wooden blocks!"
			action = "attack"
			label = "Swing"
		HatBot.Powerup.DoubleJump:
			header = "[jump]Double Jump[/jump]\nDiscovered!"
			body = "....but how?"
			action = "jump"
			label = "Jump"
		HatBot.Powerup.Climb:
			header = "[jump]Climbing Gloves[/jump]\nDiscovered!"
			body = "Hold towards a wall to grab it."
			action = "ad"
			label = "Toward wall"

	if header:
		player.move_to_target(global_position)
		var on_close = Quest.jumbo_notif({
			header=header, body=body, action=action, action_label_text=label,
			})
		if on_close:
			if not Quest.jumbo_closed.is_connected(_on_close_respawn):
				on_close.connect(_on_close_respawn.bind(on_close, player))

func _on_close_respawn(on_close, player):
	on_close.disconnect(_on_close_respawn)
	player.clear_move_target()
