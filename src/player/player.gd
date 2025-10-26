extends CharacterBody3D

@export var DragInteractionPosition : Node3D

@export_group("Note")
@export var note_content : Label

@export_group("body parts")
@export var head : Node3D
@export var camera : Camera3D

@export_group("Visual")
@export var FOV = 120
@export var crosshair_size = Vector2(12, 12)

@export_group("Mouse")
@export var SENSITIVITY = 0.001

@export_group("Physics")
@export var WALK_SPEED : float = 5.0
@export var SPRINT_SPEED : float = 8.0
@export var JUMP_VELOCITY : float = 4.5
@export var CROUCH_JUMP_VELOCITY : float = 4.5
@export var CROUCH_SPEED : float = 3.0
@export var CROUCH_INTERPOLATION : float = 6.0
@export var BOB_FREQ : float = 3.0
@export var BOB_AMP : float = 0.08
@export var BOB_SMOOTHING_SPEED : float = 3.0
@export var BOB_WAVE_LENGTH : float = 0.0
@export var gravity : float = 12.0
var speed : float

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * SENSITIVITY)
		camera.rotate_x(-event.relative.y * SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-90), deg_to_rad(90))

func _physics_process(delta):
	if is_on_floor(): # Check if the game state is not inventory or dead and if the player is on the floor
		if Input.is_action_pressed("Crouch"): # Check if the Crouch input is pressed
			scale.y = lerp(scale.y, 0.5, CROUCH_INTERPOLATION * delta) # linearly interpolate the scale of the player on the y-axis to 0.5
		else: 
			scale.y = lerp(scale.y, 1.0, CROUCH_INTERPOLATION * delta) # linearly interpolate the scale of the player on the y-axis to 1.0
	else:
		scale.y = lerp(scale.y, 1.0, CROUCH_INTERPOLATION * delta) # linearly interpolate the scale of the player on the y-axis to 1.0
	
	if !is_on_floor(): # Check if the player is not on the floor
		velocity.y -= gravity * delta # apply gravity to the player
	
	## Handle Speed
	#if Input.is_action_pressed("Sprint") and !Input.is_action_pressed("Crouch"): # Check if the Sprint input is pressed and the Crouch input is not pressed
		#speed = SPRINT_SPEED # set the speed to the sprint speed
	if Input.is_action_pressed("Crouch"): # Check if the Crouch input is pressed
		speed = CROUCH_SPEED # set the speed to the crouch speed
	else: 
		speed = WALK_SPEED # set the speed to the walk speed

	# Movement
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward") # get the input direction
	var direction = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized() # get the direction of the player

	if is_on_floor(): # Check if the player is on the floor
		if direction != Vector3.ZERO: # Check if the direction is not zero
			velocity.x = direction.x * speed # set the player's velocity on the x-axis to the direction times the speed
			velocity.z = direction.z * speed # set the player's velocity on the z-axis to the direction times the speed
		else:
			velocity.x = lerp(velocity.x, 0.0, delta * 10.0) # linearly interpolate the player's velocity on the x-axis to 0
			velocity.z = lerp(velocity.z, 0.0, delta * 10.0) # linearly interpolate the player's velocity on the z-axis to 0
	else:
		velocity.x = lerp(velocity.x, direction.x * speed, delta * 3.0) # linearly interpolate the player's velocity on the x-axis to the direction times the speed
		velocity.z = lerp(velocity.z, direction.z * speed, delta * 3.0) # linearly interpolate the player's velocity on the z-axis to the direction times the speed
		
	move_and_slide() # Apply gravity and handle movement

	# Check if the player is moving and on the floor
	var is_moving = velocity.length() > 0.1 and is_on_floor()

	# Apply view bobbing only if the player is moving
	if is_moving:
		BOB_WAVE_LENGTH += delta * velocity.length() # Increase the wave length based on the player's velocity
		camera.transform.origin = _headbob(BOB_WAVE_LENGTH) # Apply the headbob function to the camera's origin
	else:
		var target_pos = Vector3(camera.transform.origin.x, 0, camera.transform.origin.z) # get the target position
		camera.transform.origin = camera.transform.origin.lerp(target_pos, delta * BOB_SMOOTHING_SPEED) # linearly interpolate the camera's origin to the target position

func _headbob(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * BOB_FREQ) * BOB_AMP
	return pos

func _process(_delta):
	PlayerGlobal.drag_interaction_player_position = DragInteractionPosition.global_position
	camera.fov = FOV

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
