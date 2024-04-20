extends State

## properties #############################################

func can_bump():
	return false

func can_attack():
	return false

func can_be_initial_state():
	return false

func can_hop():
	return false

## vars #############################################

var ttl = 0
var time = 4

## enter #############################################

func enter(_ctx={}):
	actor.anim.play("stunned")

	# $PointLight2D.enabled = false
	# $StunnedLight.enabled = true

	ttl = time

## exit #############################################

func exit():
	ttl = null

	# $PointLight2D.enabled = true
	# $StunnedLight.enabled = false

## process #############################################

func process(delta):
	if ttl != null:
		ttl -= delta
		if ttl <= 0:
			machine.transit("Idle")
