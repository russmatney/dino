extends NaviMenu

var menu_scenes = [
	{
		"label": "Machine Movement Demo",
		"nav_to": "res://test/unit/beehive/machine/MovementDemo.tscn",
	}
]


func _ready():
	for ms in menu_scenes:
		add_menu_item(ms)
