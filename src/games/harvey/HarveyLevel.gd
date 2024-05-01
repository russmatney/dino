extends DinoLevel

# @onready var hud = $HUD

## ready ########################################################################

# var time_up_menu_scene = preload("res://src/games/harvey/menus/TimeUpMenu.tscn")
# var time_up_menu

func _ready():
	# time_up_menu = Navi.add_menu(time_up_menu_scene)

	# TODO restore!
	# P.player_ready.connect(func():
	# 	# connect to signals on player and bots
	# 	for ch in $Entities.get_children():
	# 		if ch.has_signal("produce_delivered"):
	# 			ch.produce_delivered.connect(_on_produce_delivered))

	super._ready()

## init ########################################################################

var carrot_quest
var onion_quest
var tomato_quest

func _init():
	carrot_quest = QuestDeliverProduce.new({type="carrot"})
	add_child(carrot_quest)

	onion_quest = QuestDeliverProduce.new({type="onion"})
	add_child(onion_quest)

	tomato_quest = QuestDeliverProduce.new({type="tomato"})
	add_child(tomato_quest)

## produce counts ########################################################################

var produce_counts = {}

func inc_produce_count(type):
	if type in produce_counts:
		produce_counts[type] = produce_counts[type] + 1
	else:
		produce_counts[type] = 1

	match type:
		"carrot": carrot_quest.produce_delivered()
		"onion": onion_quest.produce_delivered()
		"tomato": tomato_quest.produce_delivered()
		_: Log.warn("unexpected produce type delivered!")

	if hud and is_instance_valid(hud):
		hud.update_produce_counts(produce_counts)

## new produce #######################################################################

func _on_produce_delivered(type):
	Sounds.play(Sounds.S.complete)
	inc_produce_count(type)

## reset ########################################################################

func reset():
	produce_counts = {}
	time_remaining = initial_time_remaining
	tick_timer()

## timer ########################################################################

var initial_time_remaining = 90
var time_remaining
func tick_timer():
	if hud and is_instance_valid(hud):
		hud.update_time_remaining(time_remaining)

	if time_remaining <= 0:
		time_up()
	else:
		var tween = create_tween()
		tween.tween_callback(tick_timer).set_delay(1.0)
		time_remaining = time_remaining - 1

## time up ########################################################################

func time_up():
	var t = get_tree()
	t.paused = true
	# Navi.show_menu(time_up_menu)
	# time_up_menu.set_score(produce_counts)
