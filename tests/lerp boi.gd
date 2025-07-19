extends CharacterBody3D

var target_position = Vector3(5, 0, 0)
var max_speed = 5.0
var min_speed = 0.1

func _physics_process(delta):
	var current_pos = global_transform.origin
	var direction = target_position - current_pos
	var distance = direction.length()
	
	if current_pos.y < -50:  # Fell below void threshold
		global_transform.origin = target_position  # Reset position

	if distance > 0.01:
		var speed = clamp(distance * 5, min_speed, max_speed)
		var move_dir = direction.normalized() * speed
		
		velocity.x = move_dir.x
		velocity.z = move_dir.z
		move_and_slide()
	else:
		velocity = Vector3.ZERO
		move_and_slide()
