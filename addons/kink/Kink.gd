tool
extends Node

var ink_states = {}

func current_message(node):
	print("[KINK]: current_message for ", node.name)
	if node.name in ink_states:
		var state = ink_states[node.name]
		print(state)
		if "current_message" in state:
			return state["current_message"]
		return str("No current_message for ", node.name)
	return str("No ink_state found for ", node.name)

func new_ink_state(node):
	ink_states[node.name] = {
		"msg": "debug first msg",
		"node_name": node.name,
		}
	return ink_states[node.name]

func kink_init(node):
	print("[KINK]: initing new ink node")

	new_ink_state(node)
