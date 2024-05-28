extends CharacterBody2D
class_name SSBoss

## config warnings ###########################################################

func _get_configuration_warnings():
	return U._config_warning(self, {expected_nodes=[
		"SSBossMachine", "StateLabel", "AnimatedSprite2D",
		], expected_animations={"AnimatedSprite2D": [
			"idle", "knocked_back", "dying", "dead",
			"laughing", "stunned", "warp_arrive", "warp_leave",
			# optional/supporting optional attacks:
			# "firing",
			# "preswoop", "swooping",
			]}})

## vars ###########################################################

# stats
@export var speed = 200
@export var gravity = 1000
@export var initial_health = 5

# capabilities
@export var can_float = false # apply gravity?
@export var can_swoop = false
@export var can_fire = false

# properties
var health
var is_dead
var facing
var can_see_player

## signals ###########################################################

signal died(boss)
signal stunned(boss)

## nodes ###########################################################

@onready var machine = $SSBossMachine
@onready var anim = $AnimatedSprite2D
@onready var coll = $CollisionShape2D
@onready var state_label = $StateLabel

var notif_label
var nav_agent: NavigationAgent2D
var skull_particles
var attack_box
var los

var swoop_hint1
var swoop_hint2
var swoop_hint_player
var swoop_hints = []

## ready ###########################################################

func _ready():
	Hotel.register(self)

	U.set_optional_nodes(self, {
		notif_label="NotifLabel",
		nav_agent="NavigationAgent2D",
		skull_particles="SkullParticles",
		attack_box="AttackBox",
		los="LineOfSight",
		swoop_hint1="SwoopHint1",
		swoop_hint2="SwoopHint2",
		swoop_hint_player="SwoopHintPlayer",
		})

	if skull_particles:
		skull_particles.set_emitting(false)

	attack_box.body_entered.connect(_on_attack_box_entered)

	swoop_hints = [swoop_hint1, swoop_hint2, swoop_hint_player]\
		.filter(func(x): return x != null)
	for sh in swoop_hints:
		sh.reparent.call_deferred(get_parent())

	machine.transitioned.connect(_on_transit)

	died.connect(_on_death)

	state_label.set_visible(false)

	OffscreenIndicator.add(self, {
		# could instead depend on a fn like this directly on the passed node
		is_active=func(): return not is_dead})

func calculate_warp_spots():
	var dist_away = 200
	var maybe_targets = [
		position,
		position + Vector2.LEFT * dist_away,
		position + Vector2.RIGHT * dist_away,
		position + Vector2.UP * dist_away,
		position + Vector2.DOWN * dist_away,
		position + Vector2.LEFT * dist_away + Vector2.UP * dist_away,
		position + Vector2.LEFT * dist_away + Vector2.DOWN * dist_away,
		position + Vector2.RIGHT * dist_away + Vector2.UP * dist_away,
		position + Vector2.RIGHT * dist_away + Vector2.DOWN * dist_away,
		]

	var spots = []
	if nav_agent:
		var map_rid = nav_agent.get_navigation_map()
		var region_rids = NavigationServer2D.map_get_regions(map_rid)
		if len(region_rids) > 0: # waiting until an active region

			for pos in maybe_targets:
				nav_agent.set_target_position(pos)
				var final_pos = nav_agent.get_final_position()
				spots.append(final_pos)

	# TODO remove spots that are too close together

	if len(spots) > 0:
		return spots.map(func(pos): return {global_position=pos})

	return []

## on transit ####################################################

func _on_transit(label):
	if state_label.visible:
		state_label.text = label

## on death ####################################################

func _on_death(_boss):
	Hotel.check_in(self)
	skull_particles.set_emitting(true)

## hotel ####################################################

func check_out(data):
	global_position = data.get("position", global_position)
	health = data.get("health", initial_health)

	if health <= 0:
		if machine:
			machine.transit("Dead", {ignore_side_effects=true})

func hotel_data():
	return {health=health, position=global_position}

## facing ####################################################

func face_right():
	facing = Vector2.RIGHT
	anim.flip_h = true

func face_left():
	facing = Vector2.LEFT
	anim.flip_h = false

## process ###########################################################

var max_y = 10000 # should be fine?
func _process(_delta):
	if not is_dead and position.y > max_y:
		die()
		machine.transit("Dead")

## physics process ####################################################

func _physics_process(_delta):
	var player = Dino.current_player_node()

	if player:
		var player_pos = player.global_position
		los.target_position = to_local(player_pos)

		if los.is_colliding():
			can_see_player = true

			if not is_dead:
				if los.target_position.x > 0:
					face_right()
				else:
					face_left()

## die ####################################################

func die():
	is_dead = true

## take_hit ####################################################

func take_hit(opts={}):
	if machine.should_ignore_hit():
		Sounds.play(Sounds.S.nodamageclang)
		return

	var damage = opts.get("damage", 1)
	var direction = opts.get("direction", Vector2.UP)

	Sounds.play(Sounds.S.playerhurt)

	health -= damage
	health = clamp(health, 0, initial_health)
	Hotel.check_in(self)

	if health <= 0:
		die()

	if not is_dead and machine.state.name in ["Stunned"]:
		machine.transit("Warping")
	else:
		machine.transit("KnockedBack", {
			damage=damage,
			direction=direction,
			})

## player touch damage ####################################################

func _on_attack_box_entered(body: Node):
	if machine.can_bump():
		if body.is_in_group("player") and body.has_method("take_hit"):
			body.take_hit({body=self})
