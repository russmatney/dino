@tool
extends DotHopDot

## config warnings ###########################################################

func _get_configuration_warnings():
	return super._get_configuration_warnings()

## ready ###########################################################

func _ready():
	super._ready()
	Debug.pr("dots dot ready")

## render ###########################################################

func render():
	Debug.pr("rendering dots dotHopDot", self)
	super.render()

	match type:
		dotType.Dot: Debug.pr("rendering dots dot")
		dotType.Dotted: Debug.pr("rendering dots dotted")
		dotType.Goal: Debug.pr("rendering dots goal")
