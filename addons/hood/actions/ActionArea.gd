extends Area2D


####################################################################
# ready

func _ready():
	pass


####################################################################
# actions registry

var actions: Array = []

func register_actions(axs):
	actions = axs
