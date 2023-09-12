extends CanvasLayer

func _ready():
	Hotel.entry_updated.connect(_on_entry_updated)
	var initial_puzzle = Hotel.first({group=DotHop.puzzle_group})
	if initial_puzzle == null:
		Debug.warn("No initial puzzle found!")
	else:
		_on_entry_updated(initial_puzzle)

var last_puzzle_update

func _on_entry_updated(entry):
	last_puzzle_update = entry

	# TODO update UI
