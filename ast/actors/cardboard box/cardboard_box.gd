extends Node3D

var open : bool = false:
	set(value):
		open = value
		open_mesh.visible = open
		closed_mesh.visible = !open

@export var open_mesh : MeshInstance3D
@export var closed_mesh : MeshInstance3D

func _ready() -> void:
	open = false

func _on_interactable_component_action_triggered() -> void:
	open = !open
