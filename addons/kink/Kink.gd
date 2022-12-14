tool
extends Node

var ink_states = {}

############################################################
# current_message

func current_message(node):
	if node.name in ink_states:
		var state = ink_states[node.name]
		if "ink_player" in state:
			return state["ink_player"].get_current_text()
		return str("No current_message for ", node.name)
	return str("No ink_state found for ", node.name)

############################################################
# register

func register(node):
	# TODO unit tests:
	#   - assert node passed in has usabel ink_player set afterwards
	#   - assert warnings on missing or mis-typed kink_file (or w/e property)
	#   - assert ink_states can be accessed as expected (msg, node_name)

	print("[KINK]: initing new ink node")

	ink_states[node.name] = {
		"msg": "debug first msg",
		"node_name": node.name,
		}

	if node.kink_file:
		var ink_player = InkPlayer.new()
		ink_player.ink_file = node.kink_file

		# maybe we care about releasing this ref?
		# TODO consider WeakRef ?
		ink_states[node.name]["ink_player"] = ink_player

		node.ink_player = ink_player
	else:
		print("[WARN]: kink node without kink file", node)

	return ink_states[node.name]

############################################################
# ready

func _ready():
	if Engine.editor_hint:
		request_ready()

	print("Kink autoload ready")
