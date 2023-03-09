extends CharacterBody2D

@onready var machine = $Machine
@onready var anim = $AnimatedSprite2D
@onready var los = $LineOfSight

#####################################################
# ready

func _ready():
	if not Engine.is_editor_hint():
		machine.start()
		machine.transitioned.connect(_on_transit)

	restore()
	Hotel.check_in(self)

func _on_transit(state_label):
	Debug.pr(state_label)
	Debug.debug_label(name, "state", state_label)

#####################################################
# hotel

func restore():
	var data = Hotel.check_out(self)
	if data:
		health = data.get("health", initial_health)

func hotel_data():
	return {health=health}

#####################################################
# movement

const SPEED = 200

#####################################################
# shared process

var can_see_player

func _physics_process(_delta):
	if MvaniaGame.player:
		var player_pos = MvaniaGame.player.global_position
		los.target_position = to_local(player_pos)

		if los.is_colliding():
			can_see_player = true

#####################################################
# attack

signal fired_bullet(bullet)

#####################################################
# take_hit

var initial_health = 5
var health

func take_hit(opts={}):
	var damage = opts.get("damage", 1)
	var _dir = opts.get("direction", Vector2.UP)

	health -= damage
	Debug.pr("took hit! health", health)

	# TODO knockback state, animations, handle death there
	if health <= 0:
		queue_free()

