extends CharacterBody3D

@export var DragInteractionPosition: Node3D
@export var NoteCloseupLayer : CanvasLayer
@export var NoteContent : Label

@export_group("audio")
@export var paper_audio : AudioStreamPlayer

@export_group("timers")
@export var sleeptransitiontimer : Timer

@export_group("ui")
@export var note_content: Label
@export_subgroup("canvaslayers")
@export var hud_no_effect_layer : CanvasLayer
@export_subgroup("sleepuilayer")
@export var sleepuilayer_blackfade : ColorRect
@export_subgroup("breathing indicator")
@export var breath_interval_icon : Control
@export var accuracy_gap_icon : Control
@export var breath_interval_anim : AnimationPlayer
@export var accuracy_gap_anim : AnimationPlayer


@export_group("body parts")
@export var head: Node3D
@export var camera: Camera3D
@export var mesh : MeshInstance3D

@export_group("visual")
@export var FOV: float = 70.0
@export var crosshair_size: Vector2 = Vector2(12, 12)

@export_group("mouse")
@export var SENSITIVITY: float = 0.001

@export_group("movement")
@export var WALK_SPEED: float = 5.0
@export var SPRINT_SPEED: float = 8.0
@export var CROUCH_SPEED: float = 3.0
@export var CROUCH_INTERPOLATION: float = 6.0

@export_group("jump")
@export var JUMP_VELOCITY: float = 4.5
@export var CROUCH_JUMP_VELOCITY: float = 4.5
@export var gravity: float = 12.0

@export_group("headbob")
@export var BOB_FREQ: float = 3.0
@export var BOB_AMP: float = 0.08
@export var BOB_SMOOTHING_SPEED: float = 3.0

var speed: float
var bob_wave_length: float = 0.0

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and not PlayerGlobal.in_ui:
		_handle_mouse_look(event.relative, PlayerGlobal.player_mouse_state)

func _physics_process(delta: float) -> void:
	if not PlayerGlobal.in_ui and not PlayerGlobal.sleeping:
		_handle_crouching(delta)
		_handle_movement(delta)
		_apply_head_bob(delta)
	else:
		_stop_movement(delta)
	
	_apply_gravity(delta)
	move_and_slide()

func _handle_mouse_look(mouse_relative: Vector2, state: PlayerGlobal.PlayerMouseState) -> void:
	if state == PlayerGlobal.PlayerMouseState.NORMAL:
		head.rotate_y(-mouse_relative.x * SENSITIVITY)
		camera.rotate_x(-mouse_relative.y * SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-90), deg_to_rad(90))
	
	# mouse move slower
	elif state == PlayerGlobal.PlayerMouseState.SLOW:
		head.rotate_y(-mouse_relative.x * (SENSITIVITY / 20))
		camera.rotate_x(-mouse_relative.y * (SENSITIVITY / 20))
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-90), deg_to_rad(90))

func _handle_crouching(delta: float) -> void:
	var target_scale = 0.5 if Input.is_action_pressed("Crouch") and is_on_floor() else 1.0
	scale.y = lerp(scale.y, target_scale, CROUCH_INTERPOLATION * delta)

func _apply_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= gravity * delta

func _handle_movement(delta: float) -> void:
	speed = CROUCH_SPEED if Input.is_action_pressed("Crouch") else WALK_SPEED
	
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if is_on_floor():
		if direction != Vector3.ZERO:
			velocity.x = direction.x * speed
			velocity.z = direction.z * speed
		else:
			velocity.x = lerp(velocity.x, 0.0, delta * 10.0)
			velocity.z = lerp(velocity.z, 0.0, delta * 10.0)
	else:
		velocity.x = lerp(velocity.x, direction.x * speed, delta * 3.0)
		velocity.z = lerp(velocity.z, direction.z * speed, delta * 3.0)

func _stop_movement(delta: float) -> void:
	velocity.x = lerp(velocity.x, 0.0, delta * 10.0)
	velocity.z = lerp(velocity.z, 0.0, delta * 10.0)

func _apply_head_bob(delta: float) -> void:
	var is_moving = velocity.length() > 0.1 and is_on_floor()
	
	if is_moving:
		bob_wave_length += delta * velocity.length()
		camera.transform.origin = _headbob(bob_wave_length)
	else:
		var target_pos = Vector3(camera.transform.origin.x, 0, camera.transform.origin.z)
		camera.transform.origin = camera.transform.origin.lerp(target_pos, delta * BOB_SMOOTHING_SPEED)

func _headbob(time: float) -> Vector3:
	return Vector3(0, sin(time * BOB_FREQ) * BOB_AMP, 0)

func _process(_delta: float) -> void:
	PlayerGlobal.drag_interaction_player_position = DragInteractionPosition.global_position
	camera.fov = FOV

func _ready() -> void:
	PlayerGlobal.player = self
	
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	NoteCloseupLayer.hide()

func toggle_note_closeup(show_closup : bool, note_id : int = 1) -> void:
	if show_closup:
		paper_audio.play()
		UIGlobal.in_note_closeup = true
		PlayerGlobal.in_ui = true
		NoteContent.text = NotesGlobal.NOTE_CLOSUPS[note_id]
		NoteCloseupLayer.show()
	else:
		UIGlobal.in_note_closeup = false
		PlayerGlobal.in_ui = false
		NoteCloseupLayer.hide()

func visibilitysetupforsleep():
	hud_no_effect_layer.hide()
	mesh.hide()

func sleep():
	PlayerGlobal.sleeping = true
	PlayerGlobal.world.set_bed_can_interact(false)
	PlayerGlobal.world.breathing_mechanic.init_timer.start()
	PlayerGlobal.player_mouse_state = PlayerGlobal.PlayerMouseState.SLOW
	var tween = get_tree().create_tween()
	tween.tween_property(sleepuilayer_blackfade, "modulate", Color(1, 1, 1, 1), 1.0).from(Color(1, 1, 1, 0))
	sleeptransitiontimer.start()

func _on_sleeptransition_timeout() -> void:
	PlayerGlobal.sleepCamera.make_current()
	visibilitysetupforsleep()
	var tween = get_tree().create_tween()
	tween.tween_interval(1.0)
	tween.tween_property(sleepuilayer_blackfade, "modulate", Color(1, 1, 1, 0), 1.0).from(Color(1, 1, 1, 1))
