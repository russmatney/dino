extends State

var attacking
var punch_times = [0.3, 0.4, 0.9, 0.7, 0.8]
var punch_ttl

var punch_count
var last_hit_anything


## enter ###########################################################

func enter(opts = {}):
	attacking = opts.get("attacking", attacking)
	punch_ttl = Util.rand_of(punch_times)

	punch_count = opts.get("punch_count", 0)
	punch_count = clamp(punch_count, 0, 2)
	last_hit_anything = opts.get("hit_anything")


## exit ###########################################################

func exit():
	# attacking = null
	punch_ttl = null


## physics ###########################################################

func physics_process(delta):
	if attacking == null or punch_ttl == null:
		return

	if not attacking in actor.punch_box_bodies:
		# or maybe back to idle?
		transit("Approach", {approaching=attacking})
		return

	punch_ttl -= delta

	if punch_ttl <= 0:
		# TODO some goons move to kick sooner?
		if punch_count == 2:
			# end of combo? move to notice/approach/circle?
			transit("Kick")
			punch_count = 0
		else:
			transit("Punch", {
				punch_count=punch_count,
				next_state="Attack",})
		return
