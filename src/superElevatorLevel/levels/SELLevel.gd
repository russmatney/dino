extends Node2D
class_name SELLevel

var enemies = []
var enemy_spawn_positions = []

### ready ####################################################

func _ready():
	wave_complete.connect(_on_wave_complete)
	level_complete.connect(_on_level_complete)

	Game.maybe_spawn_player()

	enemies = get_tree().get_nodes_in_group("enemies")
	enemy_spawn_positions = get_tree().get_nodes_in_group("spawn_points")
	enemies.map(setup_enemy)

	if "waves" in self:
		Debug.pr("Setting waves", self["waves"])
		_waves = self["waves"].duplicate()

	if len(enemies) == 0:
		Debug.pr("No initial enemies, starting first wave")
		var wave = _waves.pop_front()
		if wave:
			spawn_next_wave(wave)
		else:
			Debug.warn("no wave found in SELLevel _waves, cannot spawn")


### enemies ####################################################

func setup_enemy(e):
	e.died.connect(_on_enemy_dead.bind(e))

	if not e in enemies:
		enemies.append(e)

func _on_enemy_dead(e):
	enemies.erase(e)

	if len(enemies) == 0:
		wave_complete.emit()

### waves ####################################################

signal level_complete
signal wave_complete

var goon_scene = preload("res://src/superElevatorLevel/enemies/Goon.tscn")
var boss_scene = preload("res://src/superElevatorLevel/enemies/Boss.tscn")

var _waves = [{goon_count=2}, {boss_count=1}]

func _on_wave_complete():
	if len(_waves) == 0:
		level_complete.emit()
	else:
		Hood.notif("Wave complete")
		spawn_next_wave(_waves.pop_front())

func spawn_enemies(enemy_scene, count):
	if count:
		for i in range(count):
			var e = enemy_scene.instantiate()
			setup_enemy(e)
			var sp = enemy_spawn_positions[i % len(enemy_spawn_positions)]
			e.global_position = sp.global_position
			add_child(e)

func spawn_next_wave(wave):
	enemy_spawn_positions.shuffle()

	var goon_count = wave.get("goon_count", 0)
	spawn_enemies(goon_scene, goon_count)

	# quick way to get spawns to not collide (as much)
	enemy_spawn_positions.reverse()

	var boss_count = wave.get("boss_count", 0)
	spawn_enemies(boss_scene, boss_count)

### level ####################################################

func _on_level_complete():
	Hood.notif("Level complete!")

	var sel = Engine.get_singleton("SuperElevatorLevel")
	sel.load_next_level()
