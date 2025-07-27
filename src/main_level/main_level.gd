extends Node3D

func _physics_process(_delta: float) -> void:
	$Pizza/DragInteraction.target_position = PlayerGlobal.drag_interaction_player_position
