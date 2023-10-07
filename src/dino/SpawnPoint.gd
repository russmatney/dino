@tool
extends Marker2D

@export var active = true
@export var dev_only = true

var last_visited = 0
var visit_count = 0

var spawn_f: Callable

func _enter_tree():
	Hotel.book(self)

func _ready():
	Hotel.register(self)

func check_out(data):
	last_visited = data.get("last_visited", last_visited)

func hotel_data():
	return {last_visited=last_visited}

func visited():
	last_visited = Time.get_unix_time_from_system()
	visit_count += 1
	activate()

func activate():
	active = true
func deactivate():
	active = false
