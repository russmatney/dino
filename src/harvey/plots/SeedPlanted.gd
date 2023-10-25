extends State

## enter ###########################################################

var transit_in = 2
var tt_transit


func enter(_arg = {}):
	owner.anim.animation = "seed-planted"

	tt_transit = transit_in


## process ###########################################################


func process(delta):
	tt_transit = tt_transit - delta

	if tt_transit <= 0:
		transit("NeedsWater")
