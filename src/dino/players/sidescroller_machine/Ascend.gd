extends State

var max_reach = 500

## enter ###########################################################

func enter(_opts = {}):
	pass


## exit ###########################################################

func exit():
	last_collision_point = null
	actor.warp_cast.clear_exceptions()

## warp ###########################################################

var last_collision_point

func warp_position_in_dir(_actor, direction, opts={}):
	_actor.warp_cast.target_position = direction.normalized() * max_reach
	_actor.warp_cast.force_raycast_update()

	var coll = _actor.warp_cast.get_collider()
	var seen_tilemap = opts.get("seen_tilemap")

	if seen_tilemap:
		if coll == null:
			return last_collision_point
		else:
			last_collision_point = _actor.warp_cast.get_collision_point()

	if coll != null:
		if coll is TileMap:
			opts["seen_tilemap"] = true

		var coll_rid = _actor.warp_cast.get_collider_rid()
		_actor.warp_cast.add_exception_rid(coll_rid)
		return warp_position_in_dir(_actor, direction, opts)

func warp(_actor, position):
	_actor.global_position = position + Vector2.UP * 50

## physics ###########################################################

func physics_process(_delta):
	var warp_position = warp_position_in_dir(actor, Vector2.UP)
	if warp_position != null:
		warp(actor, warp_position)
		transit("Idle")
		return

	actor.move_and_slide()
	transit("Idle")
