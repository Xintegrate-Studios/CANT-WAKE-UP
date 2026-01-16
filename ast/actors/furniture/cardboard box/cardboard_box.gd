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

func _ready() -> void:
	open = false

func _on_interactable_component_action_triggered() -> void:
	open = !open


func _on_in_box_area_body_entered(body: Node3D) -> void:
	pass # Replace with function body.


func _on_in_box_area_body_exited(body: Node3D) -> void:
	pass # Replace with function body.
