@tool
extends Node2D

@onready var entities = $Entities
@onready var tilemaps = $Tilemaps
@onready var rooms = $Rooms

var generator

## ready ######################################################

func _ready():
	Debug.pr("Shirt level!")

	for ch in get_children():
		if ch is BrickLevelGen:
			generator = ch
			ch.new_data_generated.connect(_on_new_data_generated)

## new data generated #########################################

func _on_new_data_generated(nodes: Dictionary):
	Debug.pr("new data gend", nodes)

	entities.get_children().map(func(c): c.queue_free())
	tilemaps.get_children().map(func(c): c.queue_free())
	# rooms.get_children().map(func(c): c.queue_free())

	for node in nodes.entities:
		Debug.pr("moving ent")
		node.reparent(entities)
		node.set_owner(self)

	for node in nodes.tilemaps:
		Debug.pr("moving tilemap")
		tilemaps.add_child(node)
		node.set_owner(self)

	# for node in nodes.rooms:
	# 	node.reparent(rooms)
	# 	node.set_owner(self)

	Debug.pr("resetting generator")
	generator.reset()
