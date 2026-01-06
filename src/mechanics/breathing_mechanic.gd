extends Node3D

# ======================
# DEBUG
# ======================

@export var fails_lbl : Label
@export var input_lbl : Label
@export var breath_interval_time_left_lbl : Label
@export var accuracy_gap_time_left_lbl : Label
@export var accuracy_lbl : Label
@export var average_accuracy_lbl : Label

# ======================
# CONFIG
# ======================
@export var late_zero_scale := 2.0       # forgiveness multiplier
@export var fail_release_threshold := 1.0 # seconds before window end that counts as fail

var _input_pressed_internal: bool = false
var input_pressed: bool:
	set(value):
		if _input_pressed_internal == value:
			return
		_input_pressed_internal = value
	get:
		return _input_pressed_internal


# ======================
# VARIABLES
# ======================

@export var breath_interval_timer : Timer
@export var accuracy_gap_timer : Timer

var breathing_phase := "exhale"          # always start on exhale

var accuracy_window_active := false
var window_start_ms := 0
var window_duration := 0.0

var accuracy := 0.0
var total_score := 0.0
var hits_count := 0
var cumulative_accuracy := 0.0
var fails := 0

var skip_next_accuracy := false
var skip_accuracy_threshold := 0.7  # near-next behavior

# ======================
# BUILT-IN
# ======================

func start_breathing_cycle() -> void:
	breath_interval_timer.start()

func _process(_delta: float) -> void:
	input_pressed = Input.is_action_pressed("Breath")
	
	breath_interval_time_left_lbl.text = "BREATH INTERVAL: %.2f" % breath_interval_timer.time_left
	accuracy_gap_time_left_lbl.text = "ACCURACY GAP: %.2f" % accuracy_gap_timer.time_left
	#$infolbls/breathing_phase.text = "phase: " + breathing_phase
	accuracy_lbl.text = "ACC: " + str(accuracy)
	average_accuracy_lbl.text = "AVG: " + str(cumulative_accuracy)
	fails_lbl.text = "FAILS: " + str(fails)

# ======================
# INPUT
# ======================
func _input(_event: InputEvent) -> void:
	# EXHALE: press to hold
	if Input.is_action_just_pressed("Breath") and breathing_phase == "exhale":
		_try_score()
	# INHALE: release to complete
	elif Input.is_action_just_released("Breath") and breathing_phase == "inhale":
		_try_score()

# ======================
# LOGIC
# ======================
func _try_score() -> void:
	var acc := _calculate_accuracy()
	if acc <= 0.0:
		_fail_phase()
		return
	_accept_action(acc)
	_finish_phase()

func _finish_phase() -> void:
	accuracy_window_active = false
	accuracy_gap_timer.stop()
	
	# flip phase
	breathing_phase = "exhale" if breathing_phase == "inhale" else "inhale"
	breath_interval_timer.start()

func _fail_phase(flip_phase: bool = true) -> void:
	print("FAIL - " + breathing_phase)
	fails += 1
	accuracy_window_active = false
	accuracy_gap_timer.stop()
	
	if flip_phase:
		# flip only if it's a normal fail (not window timeout fail)
		breathing_phase = "exhale" if breathing_phase == "inhale" else "inhale"
	
	breath_interval_timer.start()


# ======================
# TIMERS
# ======================
func _on_breath_interval_timeout() -> void:
	if skip_next_accuracy:
		skip_next_accuracy = false
		accuracy_window_active = false
		breathing_phase = "exhale" if breathing_phase == "inhale" else "inhale"
		breath_interval_timer.start()
		return
	_start_accuracy_window()

func _on_breath_accuracy_gap_timeout() -> void:
	if accuracy_window_active:
		# fail but **don’t flip**, let player try again in same phase
		_fail_phase(false)


func _start_accuracy_window() -> void:
	accuracy_window_active = true
	window_start_ms = Time.get_ticks_msec()
	window_duration = accuracy_gap_timer.wait_time
	accuracy_gap_timer.start()

# ======================
# SCORING
# ======================
func _calculate_accuracy() -> float:

	if window_duration <= 0.0:
		return 0.0

	var now_ms : int = Time.get_ticks_msec()
	var duration_ms : int = int(window_duration * 1000)
	@warning_ignore("integer_division")
	var center_ms : int = window_start_ms + duration_ms / 2
	@warning_ignore("integer_division")
	var ideal_ms : int = duration_ms / 2
	var dist : float = float(abs(now_ms - center_ms))

	# If player pressed too early (before the switch window), count as fail
	if dist > float(ideal_ms) * late_zero_scale:
		return 0.0

	var norm : float = 1.0 - (dist / (float(ideal_ms) * late_zero_scale))
	return clamp(round(norm * 100.0 * 100.0) / 100.0, 0.0, 100.0)

func _accept_action(acc: float) -> void:
	accuracy = acc
	total_score += acc
	hits_count += 1
	cumulative_accuracy = round((total_score / hits_count) * 100.0) / 100.0
	print("✔", breathing_phase, "accuracy:", accuracy, "AVG:", cumulative_accuracy)
