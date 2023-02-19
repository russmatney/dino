extends CanvasLayer

# var initial_vis = false
var initial_vis = true

# Called when the node enters the scene tree for the first time.
func _ready():
	set_visible(initial_vis)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _unhandled_input(event):
	if Trolley.is_debug_toggle(event):
		set_visible(!visible)
