extends Node

const TASKS = {
	
	# normal ahh tasks
	"GO_TO_BED": "Go to bed",
	"CLOTHES_AWAY": "Put your clothes in your wardrobe",
	"UNPACK_BOX": "Unpack your storage box",
	"TURN_OFF_LIGHTS": "Turn off the lights",
	"MAKE_DINNER": "Make dinner",
	"TAKE_SHOWER": "Take a shower",
	"BRUSH_TEETH": "Brush your teeth",
	"PUT_AWAY_TOYS": "Put away your toys",
	"WATER_PLANTS": "Water the plants",
	"WASH_DISHES": "Wash the dishes",
	
	# late game disturbing ahh tasks
	"KILL_YOURSELF": "Kill yourself",
	"STOP_BREATHING": "Stop breathing",
	"HOLD_BREATH_FOREVER": "Hold your fucking breath forever",
	"CUT_THROAT": "Cut your throat cunt",
}

const FIRST_NIGHT_TASKS : Array = [
	"CLOTHES_AWAY",
	"UNPACK_BOX",
	"PUT_AWAY_TOYS",
	"MAKE_DINNER",
	"WASH_DISHES",
	"BRUSH_TEETH",
]

var TASKS_TO_DO : Array = []
var TASKS_DONE_FOR_THE_NIGHT : Array = []
var TASK_NOT_DONE_NUM : int = 0


# utility functon to set a task as done/completed
func complete_task(task_name : String) -> void:
	if TASKS_TO_DO.has(task_name):
		TASKS_DONE_FOR_THE_NIGHT.append(task_name)
		TASKS_TO_DO.erase(task_name)
		TASK_NOT_DONE_NUM = TASKS_TO_DO.size()

# utility functon to set a task as uncompleted
func uncomplete_task(task_name : String) -> void:
	if TASKS_DONE_FOR_THE_NIGHT.has(task_name):
		TASKS_TO_DO.append(task_name)
		TASKS_DONE_FOR_THE_NIGHT.erase(task_name)
		TASK_NOT_DONE_NUM = TASKS_TO_DO.size()


# Initialize nightly tasks and reset counters
func set_tasks_for_night(tasks: Array) -> void:
	TASKS_TO_DO = tasks.duplicate()
	TASKS_DONE_FOR_THE_NIGHT.clear()
	TASK_NOT_DONE_NUM = TASKS_TO_DO.size()


func get_tasks_not_done_num() -> int:
	return TASK_NOT_DONE_NUM


func _ready() -> void:
	if TASKS_TO_DO.is_empty():
		set_tasks_for_night(FIRST_NIGHT_TASKS)
