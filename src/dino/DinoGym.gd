extends Node
class_name DinoGym

@export var player_scene: PackedScene

@export var genre_type: DinoData.GenreType = DinoData.GenreType.SideScroller

func _ready():
	if not Dino.current_player_entity():
		Dino.create_new_player({
			genre_type=genre_type,
			entity=Pandora.get_entity(DinoPlayerEntityIds.HATBOTPLAYER),
			})
	Dino.spawn_player({level_node=self})
