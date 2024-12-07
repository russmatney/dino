@tool
extends Node
class_name DinoGym

## vars #####################################################

@export var player_entity: DinoPlayerEntity

@export var genre: DinoData.Genre = DinoData.Genre.SideScroller

## enter tree #####################################################

func _enter_tree():
	if get_node_or_null("Camera2D") == null:
		var cam = Camera2D.new()
		cam.name = "Camera2D"
		var host = PhantomCameraHost.new()
		host.name = "PhantomCameraHost"
		cam.add_child(host)
		add_child(cam)
		cam.set_owner(self)
		host.set_owner(self)
	if get_node_or_null("DinoHUD") == null:
		var hud = load("res://src/dino/hud/DinoHUD.tscn").instantiate()
		add_child(hud)
		hud.set_owner(self)

## ready #####################################################

func _ready():
	if Engine.is_editor_hint():
		return

	if not Dino.current_player_entity():
		if not player_entity:
			player_entity = Pandora.get_entity(DinoPlayerEntityIds.HATBOTPLAYER)
		Dino.create_new_player({
			entity=player_entity,
			})
	Dino.spawn_player({level_node=self, genre=genre})
