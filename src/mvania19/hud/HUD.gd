@tool
extends CanvasLayer


##########################################
# ready

func _ready():
	Hotel.entry_updated.connect(_on_entry_updated)

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

