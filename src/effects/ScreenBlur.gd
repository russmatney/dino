extends ColorRect

var blur_tween
var gray_tween
var lod_min = 0.6
var lod_max = 2.6
var default_duration = 0.6

func set_max(lmax):
	material.set_shader_parameter("lod", lmax)

func set_min(lmin):
	material.set_shader_parameter("lod", lmin)

func anim_blur(opts={}):
	if not is_node_ready():
		return
	if blur_tween:
		blur_tween.kill()

	var duration = opts.get("duration", default_duration)
	var target = opts.get("target")
	if target == null:
		Log.warn("No target blur passed to screen animation")
		return

	blur_tween = create_tween()
	blur_tween.tween_property(material, "shader_parameter/lod", target, duration)

func anim_gray(opts={}):
	if not is_node_ready():
		return
	if gray_tween:
		gray_tween.kill()

	var duration = opts.get("duration", default_duration)
	var target = opts.get("target")
	if target == null:
		Log.warn("No target grayscale passed to screen animation")
		return

	gray_tween = create_tween()
	gray_tween.tween_property(material, "shader_parameter/grayscale", target, duration)

# TODO 'fade' is not the right word
func fade_in(opts={}):
	U.ensure_default(opts, "target", lod_max)
	anim_blur(opts)

func fade_out(opts={}):
	U.ensure_default(opts, "target", lod_min)
	anim_blur(opts)
