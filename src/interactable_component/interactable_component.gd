extends Node3D

signal action_triggered

var interacting : bool = false
var player_area_box_active : bool = false
var mimic_raycast_box_active : bool = false

@export var Contents_Node : Node3D
@export var UI_Sprite_Node : Sprite3D
@export var SubViewport_Node : SubViewport

@export var ActionToPress : InputEventAction

func _ready() -> void:
	toggle_interacting(false)

func toggle_interacting(interacting_val : bool):
	Contents_Node.visible = interacting_val
	interacting = interacting_val

func _process(_delta: float) -> void:
	if player_area_box_active and mimic_raycast_box_active:
		interacting = true
	else:
		interacting = false
