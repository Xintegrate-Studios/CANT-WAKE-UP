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

var TASKS_TO_DO : Array = []

var TASKS_DONE_FOR_THE_NIGHT : Array = []

# utility functon to set a task as done/completed
func complete_task(task_name : String) -> void:
	if TASKS_TO_DO.has(task_name):
		TASKS_DONE_FOR_THE_NIGHT.append(task_name)
		TASKS_TO_DO.erase(task_name)

var FIRST_NIGHT_TASKS : Array = [
	"CLOTHES_AWAY",
	"UNPACK_BOX",
	"PUT_AWAY_TOYS",
	"MAKE_DINNER",
	"WASH_DISHES",
	"BRUSH_TEETH",
]
