extends Quest
class_name QuestDeliverProduce

var delivered = 0

func _init(opts):
	var type = opts.get("type")
	total = opts.get("count", 1)
	label = "Deliver %s" % type

func setup():
	# overwrite default quest setup
	count_total_update.emit(total)
	count_remaining_update.emit(total - delivered)

func produce_delivered():
	delivered += 1
	var rem = total - delivered
	count_remaining_update.emit(rem)

	if rem <= 0:
		quest_complete.emit()
