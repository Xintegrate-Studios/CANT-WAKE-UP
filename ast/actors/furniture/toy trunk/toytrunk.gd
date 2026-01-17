extends Node3D

var draggables_inside : Array[DraggableBody] = []
var open : bool = false:
	set(value):
		open = value
		
		if !open:
			DraggableBodiesGlobal.let_go_of_all_bodies()
		
		if open:
			lid.rotation_degrees.z = 63.0
		else:
			lid.rotation_degrees.z = 0.0
		
		for draggable in draggables_inside:
			draggable.interaction_disabled = !open
			draggable.let_go()
			draggable.hovering_over = false
		
		#if open:
			#open_collision.process_mode = Node.PROCESS_MODE_INHERIT
			#open_draggable_collision.process_mode = Node.PROCESS_MODE_INHERIT
			#closed_collision.process_mode = Node.PROCESS_MODE_DISABLED
		#else:
			#open_collision.process_mode = Node.PROCESS_MODE_DISABLED
			#open_draggable_collision.process_mode = Node.PROCESS_MODE_DISABLED
			#closed_collision.process_mode = Node.PROCESS_MODE_INHERIT

var clothes_inside : bool = false:
	set(value):
		clothes_inside = value
		# TASKS
		if value:
			TasksGlobal.complete_task("CLOTHES_AWAY")
		else:
			TasksGlobal.uncomplete_task("CLOTHES_AWAY")

@export var lid : MeshInstance3D
@export var open_collision : StaticBody3D
@export var open_draggable_collision : StaticBody3D
@export var closed_collision : StaticBody3D

func _ready() -> void:
	open = false

func _on_trunk_toggled() -> void:
	open = !open

func _on_in_wardrobe_area_body_entered(body: Node3D) -> void:
	if body.is_in_group(&"DraggableBody"):
		draggables_inside.append(body)

func _on_in_wardrobe_area_body_exited(body: Node3D) -> void:
	if body.is_in_group(&"DraggableBody"):
		draggables_inside.erase(body)


func _on_in_wardrobe_bug_debounce_timeout() -> void:
	pass # Replace with function body.
