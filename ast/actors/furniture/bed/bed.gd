extends Node3D

func _on_bed_interacted() -> void:
	PlayerGlobal.player.sleep()
