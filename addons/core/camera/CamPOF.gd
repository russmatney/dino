# for POIs, POAs, and POFs
@tool
extends Marker2D


@export var active = true

# only relevant for POIs
@export_range(0.0, 1.0) var importance

func get_importance():
	if importance != null:
		return importance
	else:
		return 0.5

func is_active():
	return active

func activate():
	active = true

func deactivate():
	active = false