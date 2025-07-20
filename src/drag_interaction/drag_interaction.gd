extends Node
@export var body_to_drag : CharacterBody3D
@export var target_position : Vector3
@export var dragging : bool = false
@export var max_speed = 5.0
@export var min_speed = 0.1
@export var gravity = 9.8
@export var friction = 5.0  # Add friction control

func _input(event: InputEvent) -> void:
	dragging = Input.is_action_pressed("Interact2")

func _physics_process(delta: float) -> void:
	if dragging:
		# When dragging, move toward target in ALL directions (including Y)
		var current_pos = body_to_drag.global_transform.origin
		var direction = target_position - current_pos
		var distance = direction.length()
		
		if current_pos.y < -50:
			body_to_drag.global_transform.origin = target_position
			body_to_drag.velocity = Vector3.ZERO
		
		if distance > 0.01:
			var speed = clamp(distance * 5, min_speed, max_speed)
			var move_dir = direction.normalized() * speed
			
			# Move toward target in ALL directions when dragging
			body_to_drag.velocity = move_dir
		else:
			body_to_drag.velocity = Vector3.ZERO
	else:
		# When not dragging, apply gravity and friction
		if not body_to_drag.is_on_floor():
			body_to_drag.velocity.y -= gravity * delta
		else:
			body_to_drag.velocity.y = 0  # Stop bouncing on floor
		
		# Apply friction to horizontal movement
		body_to_drag.velocity.x = move_toward(body_to_drag.velocity.x, 0, friction * delta)
		body_to_drag.velocity.z = move_toward(body_to_drag.velocity.z, 0, friction * delta)
	
	body_to_drag.move_and_slide()
