extends Marker2D

@export var active = true
@export var dev_only = true

var last_sat_at = 0

func _ready():
	Hotel.register(self)

func check_out(data):
	last_sat_at = data.get("last_sat_at", last_sat_at)

func hotel_data():
	return {last_sat_at=last_sat_at}

func sat_at():
	last_sat_at = Time.get_unix_time_from_system()
	activate()

func activate():
	active = true
func deactivate():
	active = false
