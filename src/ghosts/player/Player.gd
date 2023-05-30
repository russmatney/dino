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

func update_facing():
	super.update_facing()
	Util.update_h_flip(facing_vector, $Flashlight)

############################################################


# TODO update to use take_hit/take_damage
func hit(body):
	health -= 1
	Hotel.check_in(self)

	var dir
	if body.global_position.x > global_position.x:
		dir = Vector2.LEFT
	else:
		dir = Vector2.RIGHT

	machine.transit("Knockback", {"dir": dir, "dead": health <= 0})


func _on_Hurtbox_body_entered(body: Node):
	# ignore if we're still recovering or dead
	# if knocked_back or dead:
	# 	return
	if body.is_in_group("enemies"):
		if body.can_hit_player():
			hit(body)
			Hood.notif("Youch!")
		elif body.player_can_hit():
			if body.has_method("hit"):
				var dir
				if body.global_position.x > global_position.x:
					dir = Vector2.RIGHT
				else:
					dir = Vector2.LEFT

				body.hit(dir)
				gloomba_ko()


############################################################

signal gloomba_koed
var gloomba_kos = 0


func gloomba_ko():
	Hood.notif("Gloomba K.O.!")
	gloomba_kos += 1
	Hotel.check_in(self)
	gloomba_koed.emit(gloomba_kos)
