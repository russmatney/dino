@tool
extends Node2D
class_name Checkpoint

var visit_count = 0

## config warnings ###########################################################

func _get_configuration_warnings():
	return U._config_warning(self, {expected_nodes=["ActionArea", "ActionHint"]})

## entry_tree ###########################################################

func _enter_tree():
	add_to_group(Metro.checkpoints_group, true)

## ready ###########################################################

func _ready():
	Hotel.register(self)

## hotel ###########################################################

func hotel_data():
	return {visit_count=visit_count, position=position}

# maybe should support a data-driven check-out config
func check_out(data):
	visit_count = U.get_(data, "visit_count", visit_count)

## actions ###########################################################

var actions = [
	Action.mk({label="Checkpoint", fn=visit, show_on_actor=false}),
	]

## visit ###########################################################

var player_spawn_point_scene = preload("res://src/dino/entities/PlayerSpawnPoint.tscn")

func visit(actor, opts={}):
	visit_count += 1

	actor.machine.transit("Rest", opts)

	# some way to bookmark this version of the player?
	# generally we just restore their health and powerups when they respawn
	# Hotel.check_in(actor)

	# consider drying up this add-a-spawn-point into a Metro helper-fn
	var spawn_point = get_node_or_null("PlayerSpawnPoint")
	if spawn_point == null:
		spawn_point = player_spawn_point_scene.instantiate()
		spawn_point.dev_only = false
		add_child(spawn_point)

	spawn_point.active = true
	spawn_point.visited()

	Hotel.check_in(self)
