extends Node3D

var can_interact : bool = true:
	set(value):
		can_interact = value
		$InteractableComponent/Contents/UI.visible = value

func _on_bed_interacted() -> void:
	if can_interact:
		PlayerGlobal.player.sleep()
