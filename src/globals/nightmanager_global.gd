extends Node

var NIGHT_IDX : int = 1 # default to night 1

func setup_tasks_for_night() -> void:
	if NIGHT_IDX == 1:
		TasksGlobal.TASKS_TO_DO = TasksGlobal.FIRST_NIGHT_TASKS
