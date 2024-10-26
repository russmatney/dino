@tool
extends PandoraEntity
class_name MetroTravelPointEntity

func get_destination_node_path() -> String:
	return get_string("destination_node_path")

func get_destination_zone() -> Resource:
	return get_resource("destination_zone")

func get_destination_name() -> String:
	var _zone = get_destination_zone()

	return "some place or other"

func data():
	return {
		destination_node_path=get_destination_node_path(),
		destination_zone=get_destination_zone(),
		}
