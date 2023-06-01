extends CanvasLayer

func _ready():
	# a fine register-self pattern?
	Harvey.hud = self

## timer ##################################################################

@onready var time = get_node("%Time")

func update_time_remaining(t):
	time.text = "[right]Time: " + str(t)

## produce counts ##################################################################

@onready var produce_list = get_node("%ProduceList")
var produce_count_scene = preload("res://src/harvey/HUD/ProduceCount.tscn")

func update_produce_counts(produce_counts):
	for c in produce_list.get_children():
		c.queue_free()

	for k in produce_counts:
		var ct = produce_counts[k]
		var p_count_inst = produce_count_scene.instantiate()
		produce_list.add_child(p_count_inst)
		p_count_inst.set_count(ct)
		p_count_inst.set_produce(k)
