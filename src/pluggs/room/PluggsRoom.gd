@tool
extends Node2D
class_name PluggsRoom


##########################################################################
## static ##################################################################

## room gen ##################################################################

static func gen_room_def(opts={}):
	var parsed_rooms_def = RoomParser.parse_room_defs(opts)
	var room_defs = parsed_rooms_def.rooms

	if opts.get("filter_rooms"):
		room_defs = room_defs.filter(opts.filter_rooms)

	return Util.rand_of(room_defs)
