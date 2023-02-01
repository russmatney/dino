extends CanvasLayer


func _ready():
	var _x = Harvey.connect("new_produce_delivered", self, "inc_produce_count")

	tick_timer()


###################################################################
# timer

onready var time = get_node("%Time")
# TODO variable time?
var time_remaining = 90


func tick_timer():
	time.bbcode_text = "[right]Time: " + str(time_remaining)

	if time_remaining <= 0:
		Harvey.time_up(produce_counts)
	else:
		var tween = create_tween()
		tween.tween_callback(self, "tick_timer").set_delay(1.0)
		time_remaining = time_remaining - 1


###################################################################
# produce counts

onready var produce_list = get_node("%ProduceList")
var produce_count_scene = preload("res://src/harvey/HUD/ProduceCount.tscn")
var produce_counts = {}


func inc_produce_count(type):
	if type in produce_counts:
		produce_counts[type] = produce_counts[type] + 1
	else:
		produce_counts[type] = 1

	for c in produce_list.get_children():
		c.queue_free()

	for k in produce_counts:
		var ct = produce_counts[k]
		var p_count_inst = produce_count_scene.instance()
		produce_list.add_child(p_count_inst)
		p_count_inst.set_count(ct)
		p_count_inst.set_produce(k)
