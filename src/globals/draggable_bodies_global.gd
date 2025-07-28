extends Node

var currently_hovering_over : bool = false
var currently_hovering_over_body
var currently_dragging : bool = false:
	set(value):
		currently_dragging = value
		if !value: currently_dragging_bodies.clear()
var currently_dragging_bodies = []
