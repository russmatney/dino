@tool
extends Area2D

## vars ###############################################

@onready var anim = $AnimatedSprite2D

@export var initial_anim = "idle":
	set(val):
		initial_anim = val
		$AnimatedSprite2D.play(val)

@export var drops: Array[DropData]

var is_dead = false

## ready ###############################################

func _ready():
	anim.play(initial_anim)

	body_entered.connect(on_body_entered)

func on_body_entered(body):
	take_hit({body=body})

## process ###############################################

func _physics_process(_delta):
	# TODO gravity (switch to rigid body base)
	pass

## take_hit ###############################################

var hits = 0

func take_hit(_opts):
	if is_dead:
		return
	hits += 1

	# TODO sound effect
	match hits:
		1: anim.play("damage1")
		2: anim.play("damage2")
		_:
			anim.play("damagefinal")
			is_dead = true
			if not drops.is_empty():
				for drop in drops:
					DropData.add_drop(self, drop)
