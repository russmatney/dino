@tool
extends DotHopPlayer


func _ready():
	super._ready()

## set_initial_coord #########################################################

func set_initial_coord(coord):
	current_coord = coord
	position = coord * square_size

## move #########################################################

func move_to_coord(coord):
	current_coord = coord
	position = coord * square_size

	Cam.screenshake(0.2)

## undo #########################################################

func undo_to_coord(coord):
	current_coord = coord
	position = coord * square_size

	Cam.screenshake(0.2)

# undo-step for other player, but we're staying in the same coord
func undo_to_same_coord():
	pass

## move attempts #########################################################

func move_attempt_stuck(_move_dir:Vector2):
	pass

func move_attempt_away_from_edge(_move_dir:Vector2):
	pass

func move_attempt_only_nulls(_move_dir:Vector2):
	pass
