extends State

## enter ###########################################################

var transit_in = 1
var tt_transit

func enter(_arg = {}):
	owner.anim.animation = "watered"
	tt_transit = transit_in

	# TODO sound

## process ###########################################################

func process(delta):
	tt_transit = tt_transit - delta

	if tt_transit <= 0:
		transit("ReadyForHarvest")
