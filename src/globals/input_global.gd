extends Node

func _input(_event: InputEvent) -> void:
	if OS.is_debug_build():
		if Input.is_action_just_pressed("Quit"):
			get_tree().quit()
		
		
		if Input.is_action_just_pressed("Mouse_Visible"):
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
		if Input.is_action_just_pressed("Mouse_Capture"):
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
