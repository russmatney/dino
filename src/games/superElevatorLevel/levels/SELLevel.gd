extends DinoLevel
class_name SELLevel

### vars ####################################################

var enemies = []
var enemy_spawn_positions = []

var goon_scene = preload("res://src/games/superElevatorLevel/enemies/Goon.tscn")
var boss_scene = preload("res://src/games/superElevatorLevel/enemies/Boss.tscn")

# TODO pull waves down into levelGen
var _waves = [{goon_count=2}, {boss_count=1}]

### setup_level ####################################################

func _ready():
	enemies = get_tree().get_nodes_in_group("enemies")
	enemy_spawn_positions = get_tree().get_nodes_in_group("spawn_points")
	enemies.map(setup_enemy)

	if "waves" in self:
		_waves = self["waves"].duplicate()

	if len(enemies) == 0:
		var wave = _waves.pop_front()
		if wave:
			spawn_next_wave(wave)
		else:
			Log.warn("no wave found in SELLevel _waves, cannot spawn")

	super._ready()


### enemies ####################################################

func setup_enemy(e):
	e.died.connect(_on_enemy_dead.bind(e))

	if not e in enemies:
		enemies.append(e)

func _on_enemy_dead(e):
	enemies.erase(e)

	if len(enemies) == 0:
		wave_complete()

### waves ####################################################

func all_waves_complete():
	# opt-in to DinoLevel quest completion
	on_quests_complete()

func wave_complete():
	if len(_waves) == 0:
		all_waves_complete()
	else:
		Debug.notif("Wave complete")
		spawn_next_wave(_waves.pop_front())

func spawn_enemies(enemy_scene, count):
	if count:
		for i in range(count):
			var e = enemy_scene.instantiate()
			setup_enemy(e)
			var sp = enemy_spawn_positions[i % len(enemy_spawn_positions)]
			e.global_position = sp.global_position
			$Entities.add_child(e)

func spawn_next_wave(wave):
	enemy_spawn_positions.shuffle()

	var goon_count = wave.get("goon_count", 0)
	spawn_enemies(goon_scene, goon_count)

	# quick way to get spawns to not collide (as much)
	enemy_spawn_positions.reverse()

	var boss_count = wave.get("boss_count", 0)
	spawn_enemies(boss_scene, boss_count)
