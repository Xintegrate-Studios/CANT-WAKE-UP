extends Node3D

@export var phase_switch_countdown : Timer
@export var phase_switch_countdown_lbl : Label

const LABEL_PREFIX := "PHASE SWITCH: "

func _validate_exports() -> bool:
	if phase_switch_countdown == null:
		push_error("paralysis_phase_actor: 'phase_switch_countdown' not assigned in inspector")
		return false
	if phase_switch_countdown_lbl == null:
		push_error("paralysis_phase_actor: 'phase_switch_countdown_lbl' not assigned in inspector")
		return false
	return true

func init_switch_countdown(night_idx : int) -> void:
	if not _validate_exports():
		return
	var wait_time : float = ParalysisphasemanagerGlobal.get_random_phase_length(night_idx)
	phase_switch_countdown.wait_time = wait_time
	phase_switch_countdown.start()

func START_PHASES() -> void:
	init_switch_countdown(NightmanagerGlobal.NIGHT_IDX)
	if NightmanagerGlobal.NIGHT_IDX == 1:
		_set_phase_and_log(ParalysisphasemanagerGlobal.ParalysisPhase.NORMAL)

func _set_phase_and_log(new_phase) -> void:
	ParalysisphasemanagerGlobal.SWAP_PHASE(false, new_phase)
	print("now on phase: " + str(ParalysisphasemanagerGlobal.paralysis_phase))

func _on_phase_switch_countdown_timeout() -> void:
	if NightmanagerGlobal.NIGHT_IDX != 1:
		return
	print("phase before: " + str(ParalysisphasemanagerGlobal.paralysis_phase))
	if ParalysisphasemanagerGlobal.paralysis_phase == ParalysisphasemanagerGlobal.ParalysisPhase.REALITYDISTORTION:
		print("DONE")
		return
	# restart countdown then transition to the next preset phase
	init_switch_countdown(NightmanagerGlobal.NIGHT_IDX)
	if ParalysisphasemanagerGlobal.paralysis_phase == ParalysisphasemanagerGlobal.ParalysisPhase.ENCOUNTER:
		_set_phase_and_log(ParalysisphasemanagerGlobal.ParalysisPhase.REALITYDISTORTION)
	else:
		_set_phase_and_log(ParalysisphasemanagerGlobal.ParalysisPhase.ENCOUNTER)

func _process(_delta: float) -> void:
	if phase_switch_countdown_lbl == null or phase_switch_countdown == null:
		return
	phase_switch_countdown_lbl.text = LABEL_PREFIX + ("%.1f" % phase_switch_countdown.time_left)
