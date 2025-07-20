extends Node3D

func _physics_process(delta: float) -> void:
	$MovingBody/DragInteraction.target_position = PlayerGlobal.drag_interaction_player_position
