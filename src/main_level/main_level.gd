extends Node3D

@export var breathing_mechanic : Node3D

@export var bed : Node3D

func set_bed_can_interact(value : bool = true):
	bed.can_interact = value

func _ready() -> void:
	PlayerGlobal.world = self
	PlayerGlobal.sleepCamera = $sleepCamera
	NightmanagerGlobal.setup_tasks_for_night()
	
	breathing_mechanic.start_breathing_cycle()
