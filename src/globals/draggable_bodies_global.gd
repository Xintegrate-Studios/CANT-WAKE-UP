extends Node

enum BODY_IDS {
	DEFAULT,
	CLOTHES_PILE,
	PIZZA
}

var currently_hovering_over : bool = false
var currently_hovering_over_body
var currently_dragging : bool = false:
	set(value):
		currently_dragging = value
		if !value: currently_dragging_bodies.clear()
var currently_dragging_bodies = []

func let_go_of_all_bodies():
	# Create a copy of the array to avoid modification during iteration
	var bodies_to_release = currently_dragging_bodies.duplicate()
	for body in bodies_to_release:
		if body and body.has_method("let_go"):
			body.let_go()
