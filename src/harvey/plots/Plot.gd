extends Node2D

onready var anim = $AnimatedSprite
var produce_type

var player

############################################################
# ready

func _ready():
	machine.connect("transitioned", self, "on_transit")

############################################################
# machine

onready var machine = $Machine
onready var state_label = $StateLabel
var state

func on_transit(new_state):
	state = new_state
	set_state_label(new_state)

func set_state_label(label: String):
	state_label.bbcode_text = "[center]" + label + "[/center]"

############################################################
# actions

func _on_Detectbox_body_entered(body:Node):
	if body.is_in_group("player"):
		player = body

	if body.has_method("add_action"):
		match (state):
			"ReadyForSeed": if body.has_method("plant_seed") and body.has_method("has_seed") and body.has_seed():
				body.add_action({"obj": body, "method": "plant_seed", "arg": self})
			"SeedPlanted": return
			"NeedsWater": if body.has_method("water_plant") and body.has_method("has_water") and body.has_water():
				body.add_action({"obj": body, "method": "water_plant", "arg": self})
			"Watered": return
			"ReadyForHarvest": if body.has_method("harvest_produce"):
				body.add_action({"obj": body, "method": "harvest_produce", "arg": self})
			_: print("unexpected plot state: ", state)


func _on_Detectbox_body_exited(body:Node):
	if body.has_method("remove_action"):
		# TODO remove whatever action this plot added
		# need to specify which plot so we don't remove other plot's actions
		# dictionary might not work afterall
		body.remove_action({"method": "plant_seed"})
		body.remove_action({"method": "water_plant"})
		body.remove_action({"method": "harvest_produce"})

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

func plant_seed(p_type):
	produce_type = p_type
	machine.transit("SeedPlanted", {"produce_type": p_type})

	if player:
		var dir = anim.global_position - player.get_global_position()
		deform(dir)

func water_plant():
	machine.transit("Watered")

	if player:
		var dir = anim.global_position - player.get_global_position()
		deform(dir)

func harvest_produce():
	produce_type = null
	machine.transit("ReadyForSeed")

	if player:
		var dir = anim.global_position - player.get_global_position()
		deform(dir)
