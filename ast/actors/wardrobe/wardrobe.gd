extends Node3D

var open : bool = false:
	set(value):
		open = value
		
		open_mesh.visible = open
		closed_mesh.visible = !open
		

@export var open_mesh : MeshInstance3D
@export var closed_mesh : MeshInstance3D
@export var open_collision : StaticBody3D
@export var closed_collision : StaticBody3D

func _on_wardrobe_toggled() -> void:
	open = !open
