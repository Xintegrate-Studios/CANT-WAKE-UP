extends Node3D

var draggables_inside : Array[DraggableBody] = []
var open : bool = false:
	set(value):
		open = value
		
		if open:
			lid.rotation_degrees.z = 63.0
		else:
			lid.rotation_degrees.z = 0.0
		
		for draggable in draggables_inside:
			draggable.interaction_disabled = !open
			draggable.let_go()
			draggable.hovering_over = false
		
		if open:
			open_draggable_collision.process_mode = Node.PROCESS_MODE_INHERIT
			closed_draggable_collision.process_mode = Node.PROCESS_MODE_DISABLED
		else:
			open_draggable_collision.process_mode = Node.PROCESS_MODE_DISABLED
			closed_draggable_collision.process_mode = Node.PROCESS_MODE_INHERIT

@export var lid : MeshInstance3D
@export var open_draggable_collision : StaticBody3D
@export var closed_draggable_collision : StaticBody3D

func _ready() -> void:
	open = false

	# ensure initial task state is correct
	check_completed_toys_away_task()

func _on_trunk_toggled() -> void:
	open = !open

func _on_in_toytrunk_area_body_entered(body: Node3D) -> void:
	if body.is_in_group(&"DraggableBody"):
		draggables_inside.append(body)
		check_completed_toys_away_task()

func _on_in_toytrunk_area_body_exited(body: Node3D) -> void:
	if body.is_in_group(&"DraggableBody"):
		draggables_inside.erase(body)
		check_completed_toys_away_task()

func check_completed_toys_away_task() -> void:
	var required_toys = TasksGlobal.TOYS_TO_PUT_AWAY
	if typeof(required_toys) != TYPE_ARRAY or required_toys.is_empty():
		TasksGlobal.uncomplete_task("PUT_AWAY_TOYS")
		return
	
	for req_id in required_toys:
		var found := false
		for draggable in draggables_inside:
			if draggable and typeof(draggable.ID) != TYPE_NIL and draggable.ID == req_id:
				found = true
				break
		if not found:
			TasksGlobal.uncomplete_task("PUT_AWAY_TOYS")
			return

	TasksGlobal.complete_task("PUT_AWAY_TOYS")

func _on_in_wardrobe_bug_debounce_timeout() -> void:
	pass # Replace with function body.
