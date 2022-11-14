tool
extends Position2D

# TODO dry up
var expected_group_name = "block_spawners"
# var expected_group_name = Blocks.block_spawners_group_name

# TODO create WARREN autoload for config warning helpers
# (and debug logging in general)
# could support a global config warning/debug reading UI
func _get_configuration_warning():
	var groups = get_groups()

	if not expected_group_name in groups:
		return str("Group Name expected: ", expected_group_name)
	return ""
