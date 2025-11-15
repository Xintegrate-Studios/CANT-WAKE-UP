extends Node3D

var open : bool = false:
	set(value):
		open = value
		
		
		open_mesh.visible = open
		closed_mesh.visible = !open
		
		if open:
			open_collision.process_mode = Node.PROCESS_MODE_INHERIT
			closed_collision.process_mode = Node.PROCESS_MODE_DISABLED
		else:
			open_collision.process_mode = Node.PROCESS_MODE_DISABLED
			closed_collision.process_mode = Node.PROCESS_MODE_INHERIT

@export var open_mesh : MeshInstance3D
@export var closed_mesh : MeshInstance3D
@export var open_collision : StaticBody3D
@export var closed_collision : StaticBody3D

func _on_wardrobe_toggled() -> void:
	open = !open

func _on_in_wardrobe_area_body_entered(body: Node3D) -> void:
	if body.is_in_group(&"PlayerBody"):
		PlayerGlobal.in_wardrobe = true

func _on_in_wardrobe_area_body_exited(body: Node3D) -> void:
	if body.is_in_group(&"PlayerBody"):
		PlayerGlobal.in_wardrobe = false
