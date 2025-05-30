@tool
extends Marker2D

@export var active = true
@export var dev_only = true

var last_visited = 0

func to_pretty():
	return {node=str(self), position=position, global_position=global_position}

func _ready():
	Hotel.register(self)

func check_out(data):
	last_visited = data.get("last_visited", last_visited)

func hotel_data():
	return {last_visited=last_visited}

func visited():
	last_visited = Time.get_unix_time_from_system()
	activate()

func activate():
	active = true
func deactivate():
	active = false
