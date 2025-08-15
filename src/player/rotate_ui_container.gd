extends Control

func _process(_delta: float) -> void:
	visible = DraggableBodiesGlobal.currently_dragging
