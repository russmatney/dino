extends RigidBody2D

@onready var anim = $AnimatedSprite2D

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node):
	if body.has_method("take_hit") and not body.is_dead:
		body.take_hit({body=self, damage=1})
