extends State

var swoop_in = 0.3
var swoop_ttl

var swoop_spots = []

var player_pos_set
var finished_chasing_player

#####################################################
# enter

func enter(_ctx={}):
	actor.anim.play("preswoop")

	player_pos_set = false
	finished_chasing_player = false

	var warp_spots = actor.warp_spots

	if len(warp_spots) == 0:
		warp_spots = [
			{global_position=Vector2(randf_range(-10, 10), randf_range(-10, 10))},
			{global_position=Vector2(randf_range(-10, 10), randf_range(-10, 10))},
			]

	var positions = warp_spots
	positions = positions.filter(func(ws): return not U.are_nodes_close(ws, actor))
	if len(positions) < 2:
		positions = warp_spots

	positions = U.rand_of(positions, 2)
	positions = positions.map(func(ws): return ws.global_position)

	swoop_spots = [
		[positions[0], actor.swoop_hint1],
		[func():
			if Game.player and is_instance_valid(Game.player):
				return Game.player.global_position, actor.swoop_hint_player],
		[positions[1], actor.swoop_hint2],
		]

	for spot in swoop_spots:
		show_swoop_hint(spot[1], spot[0])

func exit():
	hide_swoop_hints()

#####################################################
# physics

func physics_process(delta):
	if swoop_ttl == null:
		swoop_ttl = swoop_in

	update_player_swoop_hint()

	if not swooping:
		swoop_ttl -= delta
		if swoop_ttl <= 0:
			swoop_ttl = swoop_in

			var spot = swoop_spots.pop_front()
			if spot == null:
				machine.transit("Warping")
				return

			swoop(spot)

#####################################################
# swoop

var swooping
func swoop(spot):
	var pos

	if spot[0] is Callable:
		pos = spot[0].call()
		if pos == null:
			return
		set_player_swoop_hint(pos)
	else:
		pos = spot[0]

	swooping = true
	actor.anim.play("swooping")
	DJZ.play(DJZ.S.boss_swoop)

	var tween = create_tween()
	tween.tween_property(actor, "global_position", pos, 0.4)\
		.set_trans(Tween.TRANS_CUBIC)
	tween.tween_callback(finished_swoop.bind(spot[1]))

func finished_swoop(hint):
	swooping = false
	if player_pos_set:
		player_pos_set = false
		finished_chasing_player = true

	hide_swoop_hint(hint)

func update_player_swoop_hint():
	if player_pos_set or finished_chasing_player:
		return

	if Game.player and is_instance_valid(Game.player):
		var pos = Game.player.global_position
		actor.swoop_hint_player.global_position = pos

func set_player_swoop_hint(pos):
	actor.swoop_hint_player.global_position = pos
	player_pos_set = true

func show_swoop_hint(hint, pos):
	hint.restart()
	var p
	if pos is Callable:
		p = pos.call()
		if p == null:
			return
	else:
		p = pos
	hint.global_position = p
	hint.set_visible(true)

func hide_swoop_hints():
	for sh in actor.swoop_hints:
		hide_swoop_hint(sh)

func hide_swoop_hint(sh):
	sh.restart()
	sh.set_visible(false)
