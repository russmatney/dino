extends ColorRect

var tween
var lod_min = 0.6
var lod_max = 2.6
var default_duration = 0.6

func set_max(lmax):
	material.set_shader_parameter("LOD", lmax)

func set_min(lmin):
	material.set_shader_parameter("LOD", lmin)

func fade_in(opts={}):
	if not is_node_ready():
		return
	if tween:
		tween.kill()

	var duration = opts.get("duration", default_duration)
	var target = opts.get("target", lod_max)

	tween = create_tween()
	tween.tween_property(material, "shader_parameter/lod", target, duration)

# TODO these are the same func (different defaults)
# TODO 'fade' is not the right word
func fade_out(opts={}):
	if not is_node_ready():
		return
	if tween:
		tween.kill()

	var duration = opts.get("duration", default_duration)
	var target = opts.get("target", lod_min)

	tween = create_tween()
	tween.tween_property(material, "shader_parameter/lod", target, duration)
