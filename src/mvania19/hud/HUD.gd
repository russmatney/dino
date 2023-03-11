@tool
extends CanvasLayer


##########################################
# ready

func _ready():
	Hotel.entry_updated.connect(_on_entry_updated)

	call_deferred("update_player_data")

func update_player_data():
	var player_data = Hotel.query({is_player=true})
	if len(player_data) > 0:
		_on_entry_updated(player_data[0])
	else:
		Debug.warn("no player data yet, can't update hud")
		# call with timeout until initial success?

func _on_entry_updated(entry):
	# maybe strange to do this way... or maybe it's nice and decoupled?
	if "player" in entry["groups"]:
		set_health(entry["health"])

##########################################
# health

@onready var hearts = $%HeartsContainer

func set_health(health):
	hearts.h = health

##########################################
# minimap

# @onready var minimap = $%Minimap

