extends Node2D

onready var anim = $AnimatedSprite
var produce_type

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
	if body.has_method("add_action"):
		match (state):
			"ReadyForSeed": if body.has_method("plant_seed") and body.has_method("has_seed") and body.has_seed():
				body.add_action({"obj": body, "method": "plant_seed", "arg": self})
			"SeedPlanted": return
			"NeedsWater": if body.has_method("water_plant") and body.has_method("has_water") and body.has_water():
				body.add_action({"obj": body, "method": "water_plant", "arg": self})
			"Watered": return
			"ReadyForHarvest": if body.has_method("harvest_plant"):
				body.add_action({"obj": body, "method": "harvest_plant", "arg": self})
			_: print("unexpected plot state: ", state)


func _on_Detectbox_body_exited(body:Node):
	if body.has_method("remove_action"):
		# TODO remove whatever action this plot added
		# need to specify which plot so we don't remove other plot's actions
		# dictionary might not work afterall
		body.remove_action({"method": "plant_seed"})
		body.remove_action({"method": "water_plant"})
		body.remove_action({"method": "harvest_plant"})

############################################################
# interactions

func plant_seed(p_type):
	produce_type = p_type
	machine.transit("SeedPlanted", {"produce_type": p_type})

func water_plant():
	machine.transit("Watered")

func harvest_plant():
	produce_type = null
	machine.transit("ReadyForSeed")
