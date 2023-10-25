extends State

var entered

var attacking
var punch_times = [0.3, 0.35, 0.4, 0.45, 0.7, 0.8, 0.9]
var punch_ttl

var punch_count
var last_hit_anything


## enter ###########################################################

func enter(opts = {}):
	entered = true

	# reuse attacking, ex. if we get back here from Punch
	# this safety handling is whack, but seems to prevent some crashing
	if attacking and is_instance_valid(attacking):
		attacking = Util.get_(opts, "attacking", attacking)
	elif "attacking" in opts:
		attacking = opts["attacking"]
		if attacking and not is_instance_valid(attacking):
			attacking = null

	punch_ttl = Util.rand_of(punch_times)

	punch_count = opts.get("punch_count", 0)
	punch_count = clamp(punch_count, 0, 2)
	last_hit_anything = opts.get("hit_anything")


## exit ###########################################################

func exit():
	punch_ttl = null
	entered = false


## physics ###########################################################

func physics_process(delta):
	if not entered:
		return

	if not is_instance_valid(attacking):
		attacking = null
		transit("Idle")
		return

	if not attacking in actor.punch_box_bodies:
		# or maybe back to idle?
		# here we're expecting Approach to hold onto its 'approaching' var
		attacking = null
		transit("Approach")
		return

	punch_ttl -= delta

	if punch_ttl <= 0:
		if punch_count == 2:
			transit("Kick")
			punch_count = 0
		else:
			transit("Punch", {
				punch_count=punch_count,
				next_state="Attack",})
		return
