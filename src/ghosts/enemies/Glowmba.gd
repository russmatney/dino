tool
extends KinematicBody2D

onready var kink_label = $KinkLabel

export (Resource) var kink_file = preload("res://src/ghosts/enemies/glowmba.ink.json")

var ink_player

func _ready():
	print("Glowmba ready")
	Kink.register(self)

	call_deferred("add_child", ink_player)

	# TODO do this in register, with more warnings/validations
	ink_player.connect("ready", self, "kink_player_ready")
	ink_player.connect("loaded", self, "kink_loaded")
	ink_player.connect("continued", self, "kink_continued")
	ink_player.connect("prompt_choices", self, "kink_prompt_choices")
	ink_player.connect("ended", self, "kink_ended")


	if Engine.editor_hint:
		request_ready()

func kink_player_ready():
	print("kink player ready")
	ink_player.create_story()

func kink_loaded(success):
	print("Glowmba kink loaded, with success: ", success)
	print("My ink story: ", ink_player._story)

	ink_player.continue_story()

func kink_continued(text, tags):
	print("[KINK]: continued ", text, " tags: ", tags)

	var msg = Kink.current_message(self)
	print("msg: ", msg)

	if msg:
		kink_label.set_text(msg)

	print("[KINK]: current text:")
	print(ink_player.get_current_text())

	# TODO call in Kink?
	ink_player.continue_story()

func kink_prompt_choices(choices):
	print("[KINK]: choices", choices)

	# TODO select a choice

func kink_ended():
	print("[KINK]: ended")

#######################################################################33
# physics process

var dead = false
var dir = Vector2.RIGHT
export(int) var speed = 100
export(int) var gravity := 4000
var velocity = dir * speed

func _physics_process(delta):
	if not Engine.editor_hint:
		velocity.y += gravity * delta

		if not dead:
			velocity.x = dir.x * max(speed, velocity.x)
			velocity = move_and_slide(velocity, Vector2.UP)
			if is_on_wall():
				match dir:
					Vector2.LEFT: dir = Vector2.RIGHT
					Vector2.RIGHT: dir = Vector2.LEFT
