@tool
extends Object
class_name ParsedGame

var raw: String

var section_parsers = {
	"prelude": parse_prelude,
	"objects": parse_objects,
	}

func parse(contents):
	raw = contents
	var parsed = {}

	# force a similar prelude header
	contents = "=======\nPRELUDE\n=======\n\n" + contents
	var raw_sections = contents.split("\n\n=")
	for raw_s in raw_sections:
		var chunks = raw_s.split("\n\n")
		var header = chunks[0].split("\n")
		chunks.remove_at(0)
		header = header[1] # middle line
		var parser = section_parsers.get(header.to_lower())
		if parser:
			chunks = Array(chunks).map(func(c): return c.split("\n"))
			parsed[header.to_lower()] = parser.call(chunks)

	Debug.pr("parsed", parsed)
	return parsed

func parse_prelude(chunks):
	var lines = chunks.reduce(func(acc, x):
		acc.append_array(x)
		# fking update-in-place with no return bs
		return acc, [])
	var prelude = {}
	for l in lines:
		if l == "":
			continue
		var parts = l.split(" ", false, 1)
		var key = parts[0]
		parts.remove_at(0)
		var val = true
		if parts.size() > 0:
			val = " ".join(parts)
		# TODO cast val to non-string
		prelude[key] = val
	return prelude

func parse_objects(chunks):
	var objs = {}
	for lines in chunks:
		var obj = {}
		var nm_parts = lines[0].split(" ")
		obj.name = nm_parts[0]
		if nm_parts.size() > 1:
			obj.symbol = nm_parts[1]
		obj.colors = Array(lines[1].split(" "))
		if lines.size() > 2:
			lines.remove_at(0)
			lines.remove_at(0)
			obj.shape = parse_shape(lines)

		objs[obj.name] = obj

	return objs

func parse_shape(lines):
	var shape = []
	for l in lines:
		var row = []
		for c in l:
			if c == ".":
				row.append(null)
			else:
				row.append(int(c))
		shape.append(row)
	return shape
