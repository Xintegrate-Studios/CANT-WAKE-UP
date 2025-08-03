extends CharacterBody3D

@export var DragInteraction : Node3D
@export var MouseTexture : TextureRect

var hovering_over : bool = false

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
		DragInteraction.dragging = true
		DraggableBodiesGlobal.currently_dragging = true
		DraggableBodiesGlobal.currently_dragging_bodies.append(self)
	
	if Input.is_action_just_released("Interact3"):
		DragInteraction.dragging = false
		DraggableBodiesGlobal.currently_dragging = false
		DraggableBodiesGlobal.currently_dragging_bodies.erase(self)


func _on_player_mimic_raycast_area_area_entered(area: Area3D) -> void:
	if area.is_in_group(&"raycast_mimic"):
		hovering_over = true
		DraggableBodiesGlobal.currently_hovering_over = true
		DraggableBodiesGlobal.currently_hovering_over_body = self

func _on_player_mimic_raycast_area_area_exited(area: Area3D) -> void:
	if area.is_in_group(&"raycast_mimic"):
		hovering_over = false
		DraggableBodiesGlobal.currently_hovering_over = false
		DraggableBodiesGlobal.currently_hovering_over_body = null
