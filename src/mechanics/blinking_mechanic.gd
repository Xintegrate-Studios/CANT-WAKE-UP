extends Node3D

func _input(_event: InputEvent) -> void:
	if PlayerGlobal.sleeping:
		if Input.is_action_just_pressed("Blink"):
			PlayerGlobal.world.blink_animations.play(&"close")
		
		if Input.is_action_just_released("Blink"):
			PlayerGlobal.world.blink_animations.play(&"open")
