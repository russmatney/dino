@tool
extends SSPlayer

var tween

############################################################

var hud = preload("res://src/ghosts/hud/HUD.tscn")

func _ready():
	if not Engine.is_editor_hint():
		Hood.ensure_hud(hud)
		Cam.ensure_camera({
			player=self,
			zoom_rect_min=400,
			proximity_min=100,
			proximity_max=450,
			})

	shader_loop()

	super._ready()


###########################################################################
# hotel data

func check_out(data):
	super.check_out(data)
	gloomba_kos = data.get("gloomba_kos", 0)

func hotel_data():
	var d = super.hotel_data()
	d["gloomba_kos"] = gloomba_kos
	return d

############################################################

func shader_loop():
	tween = create_tween()
	tween.set_loops(0)

	tween.tween_property(anim.get_material(), "shader_parameter/red_displacement", 1.0, 1)
	tween.tween_property(anim.get_material(), "shader_parameter/blue_displacement", 1.0, 1)
	tween.tween_property(anim.get_material(), "shader_parameter/green_displacement", 1.0, 1)
	tween.tween_property(anim.get_material(), "shader_parameter/red_displacement", -1.0, 1)
	tween.tween_property(anim.get_material(), "shader_parameter/blue_displacement", -1.0, 1)
	tween.tween_property(anim.get_material(), "shader_parameter/green_displacement", -1.0, 1)


############################################################

# TODO should go away in favor of typical ss player/enemy interaction
func _on_Hurtbox_body_entered(body: Node):
	if body.is_in_group("enemies"):
		if body.can_hit_player():
			take_hit({body=body, damage=1})
			Hood.notif("Youch!")
		elif body.player_can_hit():
			if body.has_method("take_hit"):
				body.take_hit({body=self, damage=1})
				gloomba_ko()


############################################################

signal gloomba_koed
var gloomba_kos = 0


func gloomba_ko():
	Hood.notif("Gloomba K.O.!")
	gloomba_kos += 1
	Hotel.check_in(self)
	gloomba_koed.emit(gloomba_kos)
