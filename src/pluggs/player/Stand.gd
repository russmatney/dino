extends State


func enter(_msg = {}):
	owner.anim.animation = "idle-standing"


func process(_delta: float):
	if Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"):
		machine.transit("Run")

func physics_process(delta):
	owner.velocity.y += owner.gravity * delta
	owner.velocity = owner.move_and_slide(owner.velocity, Vector2.UP)
