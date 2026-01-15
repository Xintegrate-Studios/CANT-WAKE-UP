extends Node

var NIGHT_IDX : int = 1 # default to night 1

func setup_tasks_for_night() -> void:
	if NIGHT_IDX == 1:
		#TasksGlobal.TASKS_TO_DO = TasksGlobal.TASKS_BY_NIGHT[1]
		TasksGlobal.TASKS_TO_DO.append_array(TasksGlobal.TASKS_BY_NIGHT[1])
