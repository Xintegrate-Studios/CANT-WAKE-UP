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

# Track all draggables currently inside the box area
var draggables_inside : Array[DraggableBody] = []

@export var open_mesh : MeshInstance3D
@export var closed_mesh : MeshInstance3D
@export var open_collision : StaticBody3D
@export var closed_collision : StaticBody3D

func _ready() -> void:
	open = false
	print("Box: _ready() - initial inside count:", draggables_inside.size())
	_update_unpack_box_task()

func _on_interactable_component_action_triggered() -> void:
	open = !open
	print("Box: toggled, open =", open)


func _on_in_box_area_body_entered(body: Node3D) -> void:
	if body.is_in_group(&"DraggableBody"):
		draggables_inside.append(body)
		print("Box: body entered:", body.name, " current_count=", draggables_inside.size())
		_update_unpack_box_task()


func _on_in_box_area_body_exited(body: Node3D) -> void:
	if body.is_in_group(&"DraggableBody"):
		draggables_inside.erase(body)
		print("Box: body exited:", body.name, " current_count=", draggables_inside.size())
		_update_unpack_box_task()

func _update_unpack_box_task() -> void:
	if draggables_inside.is_empty():
		print("Box: empty -> completing UNPACK_BOX")
		TasksGlobal.complete_task("UNPACK_BOX")
	else:
		print("Box: has items -> uncompleting UNPACK_BOX (count=", draggables_inside.size(), ")")
		TasksGlobal.uncomplete_task("UNPACK_BOX")
