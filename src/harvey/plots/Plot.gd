extends Node2D

onready var anim = $AnimatedSprite
onready var action_label = $ActionLabel
var produce_type

############################################################
# ready

func _ready():
	machine.connect("transitioned", self, "on_transit")

func _process(_delta):
	if bodies:
		set_action_label(bodies[0])
	else:
		set_action_label(null)

############################################################
# machine

onready var machine = $Machine
onready var state_label = $StateLabel
var state

func on_transit(new_state):
	state = new_state

	if Harvey.debug_mode():
		set_state_label(new_state)

func set_state_label(label: String):
	state_label.set_visible(true)
	state_label.bbcode_text = "[center]" + label + "[/center]"

############################################################
# actions

var actions
var bodies = []

func build_actions(player):
	actions = [
		{"obj": self, "method": "plant_seed", "arg": player},
		{"obj": self, "method": "water_plant", "arg": player},
		{"obj": self, "method": "harvest_produce", "arg": player},
		]
	set_action_label(player)
	return actions

func can_perform_action(player, action):
	if not bodies.has(player):
		return false

	match (action["method"]):
		"plant_seed": return state == "ReadyForSeed" and player.has_seed()
		"water_plant": return state == "NeedsWater" and player.has_water()
		"harvest_produce": return state == "ReadyForHarvest"

func set_action_label(player):
	if not actions:
		return
	var ax_label
	match (state):
		"ReadyForSeed": ax_label = "plant_seed"
		"NeedsWater": ax_label = "water_plant"
		"ReadyForHarvest": ax_label = "harvest_produce"
	var ax
	for a in actions:
		if a["method"] == ax_label:
			ax = a
			break
	if not ax:
		return

	if ax_label:
		action_label.bbcode_text = "[center]" + ax_label.capitalize() + "[/center]"
	else:
		action_label.bbcode_text = ""

	if not player or not can_perform_action(player, ax):
		action_label.modulate.a = 0.5
	else:
		action_label.modulate.a = 1

	action_label.set_visible(true)

func _on_Detectbox_body_entered(body:Node):
	if body.is_in_group("player"):
		bodies.append(body)
		set_action_label(body)

func _on_Detectbox_body_exited(body:Node):
	if body.is_in_group("player"):
		bodies.erase(body)
		set_action_label(body)

##########################################################
# animate

var max_dir_distance = 100
var duration = 0.2
var reset_duration = 0.2

func deform(direction):
	var deformationStrength = clamp(max_dir_distance - direction.length(), 0, max_dir_distance) / max_dir_distance
	var deformationDirection = direction.normalized()
	var deformationScale = 0.5 * deformationDirection * deformationStrength

	var tween = create_tween()
	tween.tween_property(anim.material, "shader_param/deformation",
		deformationScale, duration).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(anim.material, "shader_param/deformation",
		Vector2.ZERO, reset_duration).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)

############################################################
# interactions

func plant_seed(player):
	produce_type = player.plant_seed()

	machine.transit("SeedPlanted", {"produce_type": produce_type})

	if player:
		var dir = anim.global_position - player.get_global_position()
		deform(dir)

func water_plant(player):
	player.water_plant()

	machine.transit("Watered")

	if player:
		var dir = anim.global_position - player.get_global_position()
		deform(dir)

func harvest_produce(player):
	player.harvest_produce(produce_type)
	produce_type = null
	machine.transit("ReadyForSeed")

	if player:
		var dir = anim.global_position - player.get_global_position()
		deform(dir)
