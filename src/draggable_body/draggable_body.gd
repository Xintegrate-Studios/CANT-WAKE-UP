class_name DraggableBody extends CharacterBody3D

@export var DragInteraction : Node3D
@export var MouseTexture : TextureRect
@export var PlayerOutOfBoundsArea : Area3D

@export var ID : DraggableBodiesGlobal.BODY_IDS

var disabled : bool = true
var hovering_over : bool = false
var in_enclosed_area : bool = false

func _physics_process(_delta: float) -> void:
	DragInteraction.target_position = PlayerGlobal.drag_interaction_player_position
	MouseTexture.visible = hovering_over and !DragInteraction.dragging

func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("Mouse_Wheel_Up") and DragInteraction.dragging:
		rotation_degrees.y += 5
	
	if Input.is_action_just_pressed("Mouse_Wheel_Down") and DragInteraction.dragging:
		
		rotation_degrees.y -= 5

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("Interact3") and hovering_over:
		grab()
	
	if Input.is_action_just_released("Interact3"):
		let_go()

func _on_player_mimic_raycast_area_area_entered(area: Area3D) -> void:
	if area.is_in_group(&"raycast_mimic") and !disabled:
		hovering_over = true
		DraggableBodiesGlobal.currently_hovering_over = true
		DraggableBodiesGlobal.currently_hovering_over_body = self

func _on_player_mimic_raycast_area_area_exited(area: Area3D) -> void:
	if area.is_in_group(&"raycast_mimic") and !disabled:
		hovering_over = false
		DraggableBodiesGlobal.currently_hovering_over = false
		DraggableBodiesGlobal.currently_hovering_over_body = null

func _on_player_out_of_bounds_area_body_exited(body: Node3D) -> void:
	if body.is_in_group(&"PlayerBody") and DraggableBodiesGlobal.currently_dragging_bodies.has(self):
		let_go()


func grab():
	DragInteraction.dragging = true
	DraggableBodiesGlobal.currently_dragging = true
	DraggableBodiesGlobal.currently_dragging_bodies.append(self)

func let_go():
	DragInteraction.dragging = false
	DraggableBodiesGlobal.currently_dragging = false
	DraggableBodiesGlobal.currently_dragging_bodies.erase(self)
