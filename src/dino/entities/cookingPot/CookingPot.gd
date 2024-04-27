extends Node2D

@onready var anim = $AnimatedSprite2D
@onready var area = $Area2D
@onready var label = $RichTextLabel
@onready var bar = $ProgressBar

var ingredients = []
var cooking = false
var cooking_time = 0.0

const cook_duration = 3.0
const required_ingredient_count = 1 # 3

func set_label(text):
	label.text = "[center]%s[/center]" % text

func _ready():
	area.body_entered.connect(_on_body_entered)

	bar.max_value = cook_duration
	set_label("ready to cook")

func _on_body_entered(body: Node):
	if body.has_method("can_be_cooked"):
		if missing_ingredient_count() == 0:
			# ignore new ingredients if we're full
			return
		if body.can_be_cooked():
			var data = body.get_data()
			start_cooking(data)
			body.queue_free()

func missing_ingredient_count():
	return required_ingredient_count - ingredients.size()

func _process(delta):
	if cooking:
		cooking_time += delta
		bar.value = cooking_time
		var rem_ing_count = missing_ingredient_count()
		if cooking_time > cook_duration and rem_ing_count == 0:
			set_label("")
			finish_cooking()
		else:
			if rem_ing_count == 0:
				set_label("creating orb")
			else:
				set_label("%s more" % rem_ing_count)

func start_cooking(data):
	ingredients.append(data)

	anim.play("cooking")

	cooking = true

	var min_cooking_time = cooking_time
	if cooking_time > 1:
		min_cooking_time = 1
	cooking_time = clamp(cooking_time, min_cooking_time, cook_duration)
	cooking_time -= 1
	cooking_time = clamp(cooking_time, min_cooking_time, cook_duration)

func finish_cooking():
	anim.play("empty")

	# TODO crafting result?!?
	var result = DropData.new(DropData.T.POWERUP)
	DropData.add_drop(self, result)

	cooking = false
	cooking_time = 0
	ingredients = []
	bar.value = 0
	set_label("ready to cook")
