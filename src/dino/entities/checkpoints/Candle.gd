@tool
extends Checkpoint

@onready var light = $PointLight2D
@onready var anim = $AnimatedSprite2D

var _actions = [
	Action.mk({
		label="Light", fn=light_up,
		source_can_execute=func(): return not is_lit(),
		show_on_source=true, show_on_actor=false,}),
	Action.mk({
		label="Sit", fn=sit,
		source_can_execute=func(): return is_lit() and not sitting,
		show_on_source=true, show_on_actor=false,}),
	]

#################################################################
# ready

func _ready():
	# overwrite actions
	actions = _actions
	super._ready()

	og_scale = light.texture_scale
	og_energy = light.energy

#################################################################
# persist/restore

func hotel_data():
	var d = super.hotel_data()
	d["lit"] = lit
	return d

func check_out(data):
	super.check_out(data)
	lit = data.get("lit", false)
	update_light()

#################################################################
# actions

@export var lit: bool = true :
	set(l):
		lit = l

func update_light():
	if lit:
		light_up()
	else:
		put_out()

func is_lit():
	return lit

func light_up(_actor=null):
	lit = true
	anim.play("flicker")
	DJZ.play(DJZ.S.candlelit)
	light.set_enabled(true)
	light_tween()
	Hotel.check_in(self)

func put_out(_actor=null):
	lit = false
	anim.play("off")
	DJZ.play(DJZ.S.candleout)
	light.set_enabled(false)
	Hotel.check_in(self)

var sitting
func sit(player):
	sitting = true

	# TODO zoom in on player. probably a pcam priority flip

	var exit_cb = func():
		put_out()
		sitting = false

	visit(player, {exit_cb=exit_cb})

## light tween ################################################################

var t
var new_scale
var new_energy
var og_scale
var og_energy

func light_tween():
	var duration = 3.0
	var reset_duration = 2.0
	var new = 0.8

	if t:
		t.kill()

	t = create_tween().set_loops()
	t.tween_property(light, "texture_scale", new, duration)
	t.parallel().tween_property(light, "energy", new, duration)
	t.tween_property(light, "texture_scale", og_scale, reset_duration)
	t.parallel().tween_property(light, "energy", og_energy, reset_duration)
