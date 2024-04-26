extends NPC

## config warnings ###########################################################

func _get_configuration_warnings():
	return super._get_configuration_warnings()

## actions ###########################################################

var actions = [
	Action.mk({
		label="Trade", fn=start_leaf_trade,
		show_on_source=true, show_on_actor=false,
		}),
	]

## leaf trade ###########################################################

func start_leaf_trade(_actor):
	# TODO transit to some reusable 'shop/interact' state
	machine.transit("Idle")

	# TODO zoom into shop cam
	# TODO show relevant control/ui nodes
