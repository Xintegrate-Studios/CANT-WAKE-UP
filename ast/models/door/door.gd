extends Node3D

enum DOOR_STATES {CLOSED, OPEN}

var DOOR_STATE : DOOR_STATES
@export var STARTING_DOOR_STATE : DOOR_STATES = DOOR_STATES.CLOSED

func _ready() -> void:
	pass
