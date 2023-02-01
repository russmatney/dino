tool
extends Node


func _ready():
	if OS.has_feature("harvey"):
		Navi.set_main_menu("res://src/harvey/menus/HarveyMenu.tscn")
		Navi.set_pause_menu("res://src/harvey/menus/HarveyPauseMenu.tscn")

	time_up_container = CanvasLayer.new()
	time_up_menu = time_up_menu_scene.instance()
	time_up_container.add_child(time_up_menu)
	call_deferred("add_child", time_up_container)

	setup_sounds()


#########################################################################
# restart


func restart_game():
	Navi.resume()  # ensure unpaused
	Navi.nav_to("res://src/harvey/maps/KitchenSink.tscn")


#########################################################################
# time up

var time_up_menu_scene = preload("res://src/harvey/menus/TimeUpMenu.tscn")
var time_up_container
var time_up_menu


func time_up(produce_counts):
	var t = get_tree()
	t.paused = true
	DJ.resume_menu_song()
	time_up_menu.show()
	time_up_menu.set_score(produce_counts)


#########################################################################
# dev mode


func debug_mode():
	# OS.is_debug_build()
	return false


signal new_produce_delivered(type)


func new_produce_delivered(type):
	sound_produce_delivered()
	emit_signal("new_produce_delivered", type)


#########################################################################
# sounds

onready var slime_stream = preload("res://assets/harvey/sounds/slime_001.ogg")
var slime_sound
onready var maximize_stream = preload("res://assets/harvey/sounds/maximize_006.ogg")
var maximize_sound
onready var minimize_stream = preload("res://assets/harvey/sounds/minimize_006.ogg")
var minimize_sound
onready var cure_stream = preload("res://assets/harvey/sounds/Retro Game Weapons Sound Effects - cure.ogg")
var cure_sound
onready var complete_stream = preload("res://assets/harvey/sounds/Retro Game Weapons Sound Effects - complete.ogg")
var complete_sound


func setup_sounds():
	slime_sound = DJ.setup_sound(slime_stream)
	minimize_sound = DJ.setup_sound(minimize_stream)
	maximize_sound = DJ.setup_sound(maximize_stream)
	cure_sound = DJ.setup_sound(cure_stream)
	complete_sound = DJ.setup_sound(complete_stream)


func sound_ready_for_harvest():
	cure_sound.play()


func sound_produce_delivered():
	complete_sound.play()


func sound_watering():
	slime_sound.play()


func sound_plant_needs_water():
	minimize_sound.play()


func sound_seed_planted():
	maximize_sound.play()
