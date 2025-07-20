extends Node

@export var body_to_drag : PhysicsBody3D
@export var target_position : Vector3
@export var dragging : bool = false
@export var max_speed = 5.0
@export var min_speed = 0.1


func _physics_process(delta: float) -> void:
	if dragging:
		var current_pos = body_to_drag.global_transform.origin
		var direction = target_position - current_pos
		var distance = body_to_drag.direction.length()
		
		if current_pos.y < -50: # Fell below void threshold
			body_to_drag.global_transform.origin = target_position # Reset position

		if distance > 0.01:
			var speed = clamp(distance * 5, min_speed, max_speed)
			var move_dir = direction.normalized() * speed
			
			body_to_drag.velocity.x = move_dir.x
			body_to_drag.velocity.z = move_dir.z
			body_to_drag.move_and_slide()
		else:
			body_to_drag.velocity = Vector3.ZERO
			body_to_drag.move_and_slide()
