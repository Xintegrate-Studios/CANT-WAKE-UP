extends Node3D

var can_interact : bool = true

func _on_bed_interacted() -> void:
	if can_interact:
		PlayerGlobal.player.sleep()
