extends Node3D

func _input(_event: InputEvent) -> void:
	if PlayerGlobal.sleeping:
		if Input.is_action_just_pressed("Blink"):
			pass
		
		if Input.is_action_just_released("Blink"):
			pass
