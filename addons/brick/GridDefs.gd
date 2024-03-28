@tool
# could write out to a pandora entity
class_name GridDefs
extends Object

var path: String
var name: String
var prelude: Dictionary
var legend: Dictionary
var grids: Array[GridDef]

func to_printable():
	return {prelude=prelude, legend=legend}

func filter(opts: Dictionary):
	U.ensure_default(opts, "flags", [])
	U.ensure_default(opts, "skip_flags", [])

	var xs = grids

	# filter out unless 'filter_rooms' returns true
	if opts.get("filter_rooms"):
		xs = xs.filter(opts.filter_rooms)

	# only keep if any matching truthy piece of room 'meta' data
	if len(opts.flags) > 0:
		xs = xs.filter(func(r):
			for flag in opts.flags:
				return r.has_flag(flag))

	# skip if any matching flag
	if len(opts.skip_flags) > 0:
		xs = xs.filter(func(r):
			for flag in opts.skip_flags:
				if r.has_flag(flag):
					return false
			return true)

	if len(xs) == 0:
		Log.warn("Could not find room_def matching `filter_rooms` and/or `flags`/`skip_flags`", opts)
		return []

	return xs
