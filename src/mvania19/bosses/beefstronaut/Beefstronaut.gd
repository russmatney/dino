extends CharacterBody2D

@onready var machine = $Machine
@onready var anim = $AnimatedSprite2D
@onready var los = $LineOfSight

const warp_group = "beef_warp_spots"
var warp_spots = []

#####################################################
# ready

func _ready():
	if not Engine.is_editor_hint():
		machine.start()
		machine.transitioned.connect(_on_transit)

	restore()
	Hotel.check_in(self)

	warp_spots = Util.get_children_in_group(get_parent(), warp_group, false)

	died.connect(_on_beef_death)

func _on_beef_death(_beefstronaut):
	Hotel.check_in(self)

func _on_transit(state_label):
	# Debug.pr(state_label)
	Debug.debug_label(name, "state", state_label)

#####################################################
# hotel

func restore():
	var data = Hotel.check_out(self)
	if data:
		global_position = data.get("position", global_position)
		health = data.get("health", initial_health)

		if health <= 0:
			if machine:
				machine.transit("Dead", {ignore_side_effects=true})

func hotel_data():
	return {health=health, position=global_position}

#####################################################
# facing

var facing

func face_right():
	facing = Vector2.RIGHT
	anim.flip_h = true

func face_left():
	facing = Vector2.LEFT
	anim.flip_h = false

#####################################################
# movement

const SPEED = 200
var GRAVITY = ProjectSettings.get_setting("physics/2d/default_gravity")

#####################################################
# shared process

var can_see_player

func _physics_process(_delta):
	if MvaniaGame.player:
		var player_pos = MvaniaGame.player.global_position
		los.target_position = to_local(player_pos)

		if los.is_colliding():
			can_see_player = true

			if los.target_position.x > 0:
				face_right()
			else:
				face_left()

#####################################################
# attack

signal fired_bullet(bullet)

#####################################################
# take_hit

var initial_health = 5
var health
var dead

signal died(beefstronaut)
signal stunned(beefstronaut)

func take_hit(opts={}):
	var damage = opts.get("damage", 1)
	var direction = opts.get("direction", Vector2.UP)

	health -= damage

	if health <= 0:
		dead = true
	machine.transit("KnockedBack", {
		damage=damage,
		direction=direction,
		})
