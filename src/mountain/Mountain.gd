@tool
extends DinoGame

const zones = [
	"res://src/mountain/zones/TheMountain.tscn"
	]

######################################################
# player

func on_player_spawned(player):
	player.died.connect(_on_player_death)

func get_spawn_coords():
	return Metro.get_spawn_coords()

func _on_player_death():
	Game.respawn_player({setup_fn=func(p): p.recover_health()})

######################################################
# register

func register():
	register_menus()

	# is this required anymore?
	Hotel.add_root_group(Metro.zones_group)

	for z in zones:
		Hotel.book(z)


######################################################
# start

func start(_opts={}):
	Metro.load_zone(zones[0])

######################################################
# update world

func update_world():
	Metro.update_zone()
