extends Node3D

var on : bool = true

@export var light_source : OmniLight3D
@export var light_mesh : MeshInstance3D

func _on_interactable_component_action_triggered() -> void:
	on = !on
	
	light_source.visible = on
	light_mesh.visible = on
