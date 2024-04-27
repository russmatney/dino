extends GPUParticles2D
class_name ParticleArea

func adjust_for_rect(rect: Rect2):
	var half_x_size = rect.size.x / 2
	var rect_top_center = rect.position + Vector2.RIGHT * half_x_size

	position = rect_top_center

	if process_material:
		process_material.emission_box_extents.x = half_x_size
