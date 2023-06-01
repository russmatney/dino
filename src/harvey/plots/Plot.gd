extends Node2D

@onready var anim = $AnimatedSprite2D
@onready var action_label = $ActionLabel
@onready var action_area = $ActionArea
var produce_type

############################################################
# ready


func _ready():
	machine.transitioned.connect(on_transit)
	machine.start()

	action_area.register_actions(actions, {source=self})
	action_area.action_display_updated.connect(set_action_label)

############################################################
# machine

@onready var machine = $Machine
@onready var state_label = $StateLabel
var state


func on_transit(new_state):
	state = new_state
	if not Game.is_managed:
		set_state_label(new_state)

	match state:
		"SeedPlanted":
			DJZ.play(DJZ.S.maximize)
		"NeedsWater":
			DJZ.play(DJZ.S.minimize)
		"Watered":
			DJZ.play(DJZ.S.slime)
		"ReadyForHarvest":
			DJZ.play(DJZ.S.cure)
		_:
			Debug.prn("no sound")


func set_state_label(label: String):
	state_label.set_visible(true)
	state_label.text = "[center]" + label + "[/center]"


############################################################
# actions

var actions = [
	Action.mk({label="Plant Seed", fn=plant_seed,
		source_can_execute=func(): return state == "ReadyForSeed",
		actor_can_execute=func(player): return not player.has_produce() and player.has_seed(),
		}),
	Action.mk({label="Water Plant", fn=water_plant,
		source_can_execute=func(): return state == "NeedsWater",
		actor_can_execute=func(player): return not player.has_produce() and player.has_water(),
		}),
	Action.mk({label="Harvest", fn=harvest_produce,
		source_can_execute=func(): return state == "ReadyForHarvest",
		actor_can_execute=func(player): return not player.has_produce(),
		}),
	]

func set_action_label():
	var axs = action_area.current_actions()
	if axs.size() == 0:
		action_label.set_visible(false)
		return

	# TODO what to do when two different actions are current (for two actors)
	var ax = axs[0]

	action_label.text = "[center]" + ax.label.capitalize() + "[/center]"
	action_label.modulate.a = 1
	action_label.set_visible(true)


##########################################################
# animate

var max_dir_distance = 100
var duration = 0.2
var reset_duration = 0.2


func deform(direction):
	var deformationStrength = (
		clamp(max_dir_distance - direction.length(), 0, max_dir_distance)
		/ max_dir_distance
	)
	var deformationDirection = direction.normalized()
	var deformationScale = 0.5 * deformationDirection * deformationStrength

	var tween = create_tween()
	tween.tween_property(anim.material, "shader_parameter/deformation", deformationScale, duration).set_trans(
		Tween.TRANS_CUBIC
	)
	tween.tween_property(anim.material, "shader_parameter/deformation", Vector2.ZERO, reset_duration).set_trans(Tween.TRANS_CUBIC).set_ease(
		Tween.EASE_IN_OUT
	)


############################################################
# interactions


func plant_seed(player):
	produce_type = player.plant_seed()

	machine.transit("SeedPlanted", {"produce_type": produce_type})

	if player:
		var dir = anim.global_position - player.get_global_position()
		deform(dir)


func needs_water():
	return state == "NeedsWater"


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
