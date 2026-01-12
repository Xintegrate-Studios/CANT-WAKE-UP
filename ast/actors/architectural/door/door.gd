extends Node3D

enum DOOR_STATES {CLOSED, OPEN}

var DOOR_STATE : DOOR_STATES

@export var DoorAnimation : AnimationPlayer
@export var HingePivot : Node3D
@export var STARTING_DOOR_STATE : DOOR_STATES

func _ready() -> void:
	DOOR_STATE = STARTING_DOOR_STATE
	if DOOR_STATE == DOOR_STATES.CLOSED:
		HingePivot.rotation_degrees.y = 90
	else:
		HingePivot.rotation_degrees.y = 0

func _door_triggered() -> void:
	if DOOR_STATE == DOOR_STATES.CLOSED:
		DOOR_STATE = DOOR_STATES.OPEN
		DoorAnimation.play(&"main", -1, -1, true)
	else:
		DOOR_STATE = DOOR_STATES.CLOSED
		DoorAnimation.play(&"main")
		
		
		
