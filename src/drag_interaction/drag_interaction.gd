extends Node
@export var body_to_drag : CharacterBody3D
@export var target_position : Vector3
@export var dragging : bool = false
@export var drag_force = 10.0  # How strong the pull toward target is
@export var drag_damping = 0.8  # Reduces velocity each frame (0.8 = 20% reduction)
@export var gravity = 9.8
@export var friction = 5.0

func _input(_event: InputEvent) -> void:
	dragging = Input.is_action_pressed("Interact3")

func _physics_process(delta: float) -> void:
	if dragging:
		var current_pos = body_to_drag.global_transform.origin
		var direction = target_position - current_pos
		var distance = direction.length()
		
		if current_pos.y < -50:
			body_to_drag.global_transform.origin = target_position
			body_to_drag.velocity = Vector3.ZERO
		
		# Simple force-based movement
		if distance > 0.01:
			var force = direction * drag_force * delta
			body_to_drag.velocity += force
			
			# Apply damping to prevent oscillation
			body_to_drag.velocity *= drag_damping
		else:
			# Strong damping when very close
			body_to_drag.velocity *= 0.5
	else:
		# When not dragging, apply gravity and friction
		if not body_to_drag.is_on_floor():
			body_to_drag.velocity.y -= gravity * delta
		else:
			body_to_drag.velocity.y = 0
		
		body_to_drag.velocity.x = move_toward(body_to_drag.velocity.x, 0, friction * delta)
		body_to_drag.velocity.z = move_toward(body_to_drag.velocity.z, 0, friction * delta)
	
	body_to_drag.move_and_slide()
