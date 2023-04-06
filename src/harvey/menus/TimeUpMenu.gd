extends CanvasLayer

###################################################################
# produce counts

@onready var score_label = get_node("%ScoreLabel")
@onready var produce_list = get_node("%ProduceList")
var produce_count_scene = preload("res://src/harvey/HUD/ProduceCount.tscn")


func set_score(produce_counts):
	if len(produce_counts) == 0:
		score_label.text = "[center]" + "No Veggies Delivered!"
		return

	for c in produce_list.get_children():
		c.queue_free()

	# TODO animate?
	for k in produce_counts:
		var ct = produce_counts[k]
		var p_count_inst = produce_count_scene.instantiate()
		p_count_inst.alignment = 1  # align center
		produce_list.add_child(p_count_inst)
		p_count_inst.set_count(ct)
		p_count_inst.set_produce(k)
