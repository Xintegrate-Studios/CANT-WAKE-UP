extends Node

var NIGHT_IDX : int = 1 # default to night 1

func setup_tasks_for_night() -> void:
	if NIGHT_IDX == 1:
		# Use the TasksGlobal helper to replace the tasks for the night
		TasksGlobal.set_tasks_for_night_by_index(NIGHT_IDX)
