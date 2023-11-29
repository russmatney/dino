extends Node2D
class_name SSWeapon

func _get_configuration_warnings():
	return U._config_warning(self, {expected_nodes=[]})

## vars #####################################################

var anim
var hitbox
var hitbox_coll

var display_name: String
var actor

var should_flip = true

## enter_tree #####################################################

func _enter_tree():
	add_to_group("weapons", true)

## ready #####################################################

func _ready():
	actor = get_parent()

	if display_name == null or display_name == "":
		display_name = name

	U.set_optional_nodes(self, {
		anim="AnimatedSprite2D",
		hitbox="HitBox",
		hitbox_coll="HitBox/ColliionShape2D",
		})

	if anim:
		anim.animation_finished.connect(_on_animation_finished)
		anim.frame_changed.connect(_on_frame_changed)

	if hitbox:
		hitbox.area_entered.connect(_on_body_entered)
		hitbox.area_exited.connect(_on_body_exited)
		hitbox.body_entered.connect(_on_body_entered)
		hitbox.body_exited.connect(_on_body_exited)
		hitbox.body_shape_entered.connect(_on_body_shape_entered)
		hitbox.body_shape_exited.connect(_on_body_shape_exited)

## public api #####################################################

func aim(aim_vector: Vector2):
	Log.pr("impl aim!", self)

func activate():
	Log.pr("impl activate!", self)

func deactivate():
	Log.pr("impl deactivate!", self)

func use():
	Log.pr("impl use!", self)

func stop_using():
	Log.pr("impl stop using!", self)

## helpers #####################################################

func _on_animation_finished():
	pass

func _on_frame_changed():
	pass

## bodies #####################################################

var bodies = []
var body_shapes = []

func _on_body_entered(body: Node2D):
	bodies.append(body)

func _on_body_exited(body: Node2D):
	bodies.erase(body)

func _on_body_shape_entered(rid, body: Node2D, _bs_idx, _local_idx):
	body_shapes.append([rid, body])

func _on_body_shape_exited(rid, body: Node2D, _bs_idx, _local_idx):
	body_shapes.erase([rid, body])
