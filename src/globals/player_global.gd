extends Node

enum PlayerMouseState {SLOW, NORMAL}
var player_mouse_state : PlayerMouseState = PlayerMouseState.NORMAL

var drag_interaction_player_position : Vector3
var in_wardrobe : bool = false

var sleeping : bool = false
var in_ui : bool = false

var player : CharacterBody3D
var world : Node3D
var sleepCamera : Camera3D
