extends Node3D

var draggables_inside : Array = [DraggableBody]


var open : bool = false:
	set(value):
		open = value
		
		# if in wardrobe and its closed, stop dragging objects
		if !open and PlayerGlobal.in_wardrobe:
			DraggableBodiesGlobal.let_go_of_all_bodies()
		
		open_mesh.visible = open
		closed_mesh.visible = !open
		
		if open:
			open_collision.process_mode = Node.PROCESS_MODE_INHERIT
			open_draggable_collision.process_mode = Node.PROCESS_MODE_INHERIT
			closed_collision.process_mode = Node.PROCESS_MODE_DISABLED
		else:
			open_collision.process_mode = Node.PROCESS_MODE_DISABLED
			open_draggable_collision.process_mode = Node.PROCESS_MODE_DISABLED
			closed_collision.process_mode = Node.PROCESS_MODE_INHERIT
			
			for draggable in draggables_inside:
				draggable

var clothes_inside : bool = false:
	set(value):
		clothes_inside = value
		# TASKS
		if value:
			TasksGlobal.complete_task("CLOTHES_AWAY")
		else:
			TasksGlobal.uncomplete_task("CLOTHES_AWAY")

@export var open_mesh : MeshInstance3D
@export var closed_mesh : MeshInstance3D
@export var open_collision : StaticBody3D
@export var open_draggable_collision : StaticBody3D
@export var closed_collision : StaticBody3D



func _ready() -> void:
	open = false

func _on_wardrobe_toggled() -> void:
	open = !open


func _on_in_wardrobe_area_body_entered(body: Node3D) -> void:
	if body.is_in_group(&"DraggableBody"):
		draggables_inside.append(body)
		if body.ID == DraggableBodiesGlobal.BODY_IDS.CLOTHES_PILE:
			print("--clothes inside wardrobe")
			clothes_inside = true


func _on_in_wardrobe_area_body_exited(body: Node3D) -> void:
	if body.is_in_group(&"DraggableBody"):
		draggables_inside.erase(body)
		if body.ID == DraggableBodiesGlobal.BODY_IDS.CLOTHES_PILE:
			print("!--clothes outside wardrobe")
			clothes_inside = false
