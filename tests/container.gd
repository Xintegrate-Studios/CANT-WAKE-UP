@tool
extends Control

@onready var texture_rect: TextureRect = $TextureRect
@onready var control: Control = $Control

func _process(_delta):
	var mask_global = control.get_global_rect()

	# Convert mask position into TextureRect local space
	var local_pos = texture_rect.to_local(mask_global.position)

	texture_rect.material.set_shader_parameter("mask_pos", local_pos)
	texture_rect.material.set_shader_parameter("mask_size", mask_global.size)
