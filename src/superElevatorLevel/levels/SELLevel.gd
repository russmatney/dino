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

var _waves = []

func _on_wave_complete():
	if len(_waves) == 0:
		level_complete.emit()
	else:
		Hood.notif("Wave complete")
		var next_wave = _waves.pop_front()
		Debug.pr("next wave: ", next_wave)
		spawn_next_wave(next_wave)

func spawn_next_wave(wave):
	var goon_count = wave.get("goon_count")
	enemy_spawn_positions.shuffle()
	for i in range(goon_count):
		# TODO better enemy names
		var g = goon_scene.instantiate()
		setup_enemy(g)
		var sp = enemy_spawn_positions[i % len(enemy_spawn_positions)]
		g.global_position = sp.global_position
		add_child(g)

### level ####################################################

func _on_level_complete():
	Hood.notif("Level complete!")

	SuperElevatorLevel.load_next_level()
