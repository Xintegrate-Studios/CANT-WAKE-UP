extends Node3D

signal action_triggered

var interacting : bool = false

var player_area_box_active : bool = false
var mimic_raycast_box_active : bool = false

func _process(_delta: float) -> void:
	if player_area_box_active and mimic_raycast_box_active:
		interacting = true
	else:
		interacting = false
