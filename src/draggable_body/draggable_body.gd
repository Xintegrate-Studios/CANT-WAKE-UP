extends CharacterBody3D

@export var DragInteraction : Node3D

func _physics_process(_delta: float) -> void:
	DragInteraction.target_position = PlayerGlobal.drag_interaction_player_position
