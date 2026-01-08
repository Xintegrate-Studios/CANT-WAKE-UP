extends Node3D

# phases:
# OPEN
# CLOSING
# CLOSED
# OPENING

var BLINKING_PHASE : String = "OPEN"

func _input(_event: InputEvent) -> void:
	if PlayerGlobal.sleeping:
		if Input.is_action_just_pressed("Blink"):
			PlayerGlobal.world.blink_animations.play(&"close")
		
		if Input.is_action_just_released("Blink"):
			PlayerGlobal.world.blink_animations.play(&"open")


# blinking phase handling

func _on_blink_animations_animation_finished(anim_name: StringName) -> void:
	if anim_name == &"open":
		BLINKING_PHASE = "OPEN"
	if anim_name == &"close":
		BLINKING_PHASE = "CLOSED"

func _on_blink_animations_animation_started(anim_name: StringName) -> void:
	if anim_name == &"open":
		BLINKING_PHASE = "OPENING"
	if anim_name == &"close":
		BLINKING_PHASE = "CLOSING"
