extends Node3D

func _ready() -> void:
	PlayerGlobal.sleepCamera = $sleepCamera
	NightmanagerGlobal.setup_tasks_for_night()
