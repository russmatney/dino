@tool
extends NaviButtonList

var menu_scenes = [
	{
		label="Clawe Dashboard",
		nav_to="res://src/clawe/ClaweDashboard.tscn",
	},
	{
		label="Credits",
		nav_to="res://src/dino/DinoCredits.tscn",
	},
	{
		label="Toggle Pause",
		fn=Navi.toggle_pause,
	},
	{
		label="Show Win Menu",
		fn=Navi.show_win_menu,
	},
	{
		label="Show Death Menu",
		fn=Navi.show_death_menu,
	}
]


func _ready():
	for ms in menu_scenes:
		add_menu_item(ms)

	if Engine.is_editor_hint():
		request_ready()