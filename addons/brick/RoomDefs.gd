# could write out to a pandora entity
class_name RoomDefs
extends Object

var path: String
var name: String
var prelude: Dictionary
var legend: Dictionary
var rooms: Array[RoomDef]

func to_pretty(obj, a, b, c):
	return Debug.to_pretty({prelude=prelude, legend=legend}, a, b, c)

func filter(opts: Dictionary):
	Util.ensure_default(opts, "flags", [])
	Util.ensure_default(opts, "skip_flags", [])

	var xs = rooms

	# filter out unless 'filter_rooms' returns true
	if opts.get("filter_rooms"):
		xs = xs.filter(opts.filter_rooms)

	# only keep if any matching truthy piece of room 'meta' data
	if len(opts.flags) > 0:
		xs = xs.filter(func(r):
			for flag in opts.skip_flags:
				return r.has_flag(flag))

	# skip if any matching flag
	if len(opts.skip_flags) > 0:
		xs = xs.filter(func(r):
			for flag in opts.flags:
				if r.has_flag(flag):
					return false
			return true)

	if len(xs) == 0:
		Debug.err("Could not find room_def matching `keep_rooms` and/or `flags`", opts.flags)
		return

	return xs
