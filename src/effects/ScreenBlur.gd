extends ColorRect

var tween
var lod_min = 0.6
var lod_max = 2.6
var default_duration = 0.6

func fade_in(opts={}):
	if tween:
		tween.kill()

	var duration = opts.get("duration", default_duration)

	tween = create_tween()
	tween.tween_property(material, "shader_parameter/LOD", lod_max, duration)

func fade_out(opts={}):
	if tween:
		tween.kill()

	var duration = opts.get("duration", default_duration)

	tween = create_tween()
	tween.tween_property(material, "shader_parameter/LOD", lod_min, duration)
