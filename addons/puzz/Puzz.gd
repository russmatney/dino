extends Node

func parse_game(path):
	# TODO make sure file exists
	var file = FileAccess.open(path, FileAccess.READ)
	var contents = file.get_as_text()
	var parsed = parse_contents(contents)

	return parsed

func parse_contents(contents):
	var parsed = {}

	# force a similar prelude header
	contents = "=======\nPRELUDE\n=======\n\n" + contents
	var raw_sections = contents.split("\n\n=")
	for raw_s in raw_sections:
		Debug.pr("parsing section: ", raw_s)
		var chunks = raw_s.split("\n\n")
		var header = chunks[0].split("\n")
		chunks.remove_at(0)
		header = header[1] # middle line
		Debug.pr("found header", header)
		var parser = section_parsers.get(header.to_lower())
		if parser:
			chunks = Array(chunks).map(func(c): return c.split("\n"))
			parsed[header.to_lower()] = parser.call(chunks)

	Debug.pr("parsed", parsed)
	return parsed

var section_parsers = {
	"prelude": parse_prelude,
	"objects": parse_objects,
	}

func parse_prelude(chunks):
	Debug.pr("chunks", chunks)
	var lines = chunks.reduce(func(acc, x):
		acc.append_array(x)
		# fking update-in-place with no return bs
		return acc, [])
	var prelude = {}
	for l in lines:
		Debug.pr("line", l)
		if l == "":
			continue
		var parts = l.split(" ", false, 1)
		Debug.pr("parts", parts)
		var key = parts[0]
		parts.remove_at(0)
		var val = true
		if parts.size() > 0:
			val = " ".join(parts)
		# TODO cast val to non-string
		prelude[key] = val
	return prelude

func parse_objects(chunks):
	chunks.remove_at(0) # drop header

	return {}
