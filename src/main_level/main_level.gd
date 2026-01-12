extends Node3D

@export var bed : Node3D

@export var breathing_mechanic : Node3D
@export var blinking_mechanic : Node3D
@export var blink_animations : AnimationPlayer

@export var sleep_head : Node3D
@export var sleep_camera : Camera3D

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and not PlayerGlobal.in_ui and PlayerGlobal.sleeping:
		_handle_mouse_look(event.relative)

func _handle_mouse_look(mouse_relative: Vector2) -> void:
	sleep_head.rotate_y(-mouse_relative.x * 0.00005)
	sleep_camera.rotate_x(-mouse_relative.y * 0.00005)
	sleep_camera.rotation.x = clamp(sleep_camera.rotation.x, deg_to_rad(-40), deg_to_rad(40))
	sleep_head.rotation.y = clamp(sleep_head.rotation.y, deg_to_rad(-130), deg_to_rad(0))
	

func set_bed_can_interact(value : bool = true):
	bed.can_interact = value

func _ready() -> void:
	PlayerGlobal.world = self
	PlayerGlobal.sleepCamera = $sleepCameraHead/sleepCamera
	NightmanagerGlobal.setup_tasks_for_night()
