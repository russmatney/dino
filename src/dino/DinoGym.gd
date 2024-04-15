extends Node
class_name DinoGym

@export var player_entity: DinoPlayerEntity

@export var genre_type: DinoData.GenreType = DinoData.GenreType.SideScroller

func _ready():
	if not Dino.current_player_entity():
		if not player_entity:
			player_entity = Pandora.get_entity(DinoPlayerEntityIds.HATBOTPLAYER)
		Dino.create_new_player({
			genre_type=genre_type,
			entity=player_entity,
			})
	Dino.spawn_player({level_node=self})
