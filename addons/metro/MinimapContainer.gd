@tool
extends PanelContainer


##########################################
# ready

func _ready():
	Hotel.entry_updated.connect(_on_entry_updated)

func _on_entry_updated(entry):
	if Metro.rooms_group in entry["groups"]:
		update_minimap(entry)


##########################################
# minimap

# @onready var minimap = $%Minimap

@onready var zone_name = $%ZoneName
@onready var room_name = $%RoomName

func update_minimap(room):
	if room.get("has_player"):
		zone_name.text = room.get("zone_name").capitalize()
		room_name.text = room.get("name").capitalize()
