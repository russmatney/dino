extends Node2D

@onready var area = $Area2D

@export var expected_delivery_type: Spike.Ingredient = Spike.Ingredient.RedBlob
@export var expected_delivery_count = 1
var delivery_count = 0

var complete = false

func _ready():
	area.body_entered.connect(_on_body_entered)

	var ing_data = Spike.all_ingredients[expected_delivery_type]

	Quest.register_quest(self, {label=str("FEED THE VOID: %s" % ing_data.name)})
	update_quest()

func _on_body_entered(body: Node):
	if body.has_method("is_delivery") and body.is_delivery():
		if not complete and body.ingredient_type == expected_delivery_type:
			delivery_count += 1
			Debug.pr("delivered", body, body.ingredient_data)

			Hood.notif("Delivery!", body.ingredient_data.name)

			# TODO animate delivery/fade
			body.queue_free()
			update_quest()
		else:
			# TODO THROW IT BACK
			if complete:
				Hood.notif("I'M FULL!")
			else:
				Hood.notif("THIS IS NOT MY ORDER!")

# quest impl

func _exit_tree():
	if Engine.is_editor_hint():
		return
	Quest.unregister(self)

signal quest_complete
signal quest_failed
signal count_remaining_update
signal count_total_update

func update_quest():
	count_remaining_update.emit(expected_delivery_count - delivery_count)
	count_total_update.emit(expected_delivery_count)

	if delivery_count >= expected_delivery_count:
		complete = true
		quest_complete.emit()
