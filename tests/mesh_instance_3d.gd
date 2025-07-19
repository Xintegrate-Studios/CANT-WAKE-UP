extends StaticBody3D

var target_position = Vector3(5, 0, 0)  # example target
var lerp_speed = 0.1  # how fast to lerp (between 0 and 1)

func _process(delta):
	# current global position
	var current_pos = global_transform.origin
	
	# lerp toward target
	var new_pos = current_pos.lerp(target_position, lerp_speed)
	
	# update position (global_transform.origin)
	global_transform.origin = new_pos
