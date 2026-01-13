extends Node3D

@export var phase_switch_countdown : Timer
@export var phase_switch_countdown_lbl : Label

signal wake_up
signal enter_false_reality

var completed_phases_count : int = 0

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
	completed_phases_count = 0 # reset counter
	var night_idx : int = NightmanagerGlobal.NIGHT_IDX
	# Night 1 is a tutorial: force the preset sequence starting at NORMAL
	if night_idx == 1:
		ParalysisphasemanagerGlobal.SWAP_PHASE(false, ParalysisphasemanagerGlobal.ParalysisPhase.NORMAL)
		init_switch_countdown(night_idx)
		return
	# other nights pick phases via the phase manager
	ParalysisphasemanagerGlobal.SWAP_PHASE(true)
	init_switch_countdown(night_idx)

func _set_phase_and_log(new_phase) -> void:
	ParalysisphasemanagerGlobal.SWAP_PHASE(false, new_phase)
	print("now on phase: " + str(ParalysisphasemanagerGlobal.paralysis_phase))

func _on_phase_switch_countdown_timeout() -> void:
	# A phase has completed
	completed_phases_count += 1
	var night_idx : int = NightmanagerGlobal.NIGHT_IDX
	print("phase before: " + str(ParalysisphasemanagerGlobal.paralysis_phase))

	# Night 1 tutorial: follow fixed sequence NORMAL -> ENCOUNTER -> REALITYDISTORTION
	if night_idx == 1:
		if ParalysisphasemanagerGlobal.paralysis_phase == ParalysisphasemanagerGlobal.ParalysisPhase.REALITYDISTORTION:
			print("tutorial finished: reached REALITYDISTORTION")
			emit_signal("enter_false_reality")
			return
		# restart countdown then transition to the next preset phase
		init_switch_countdown(night_idx)
		if ParalysisphasemanagerGlobal.paralysis_phase == ParalysisphasemanagerGlobal.ParalysisPhase.ENCOUNTER:
			_set_phase_and_log(ParalysisphasemanagerGlobal.ParalysisPhase.REALITYDISTORTION)
		else:
			_set_phase_and_log(ParalysisphasemanagerGlobal.ParalysisPhase.ENCOUNTER)
		return

	# retrieve thresholds and chances from the global manager
	var min_phases : int = 1
	if night_idx in ParalysisphasemanagerGlobal.min_phases_by_night:
		min_phases = int(ParalysisphasemanagerGlobal.min_phases_by_night[night_idx])
	else:
		push_error("paralysis_phase_actor: min_phases not defined for night %d" % night_idx)

	var soft_max : int = -1
	if night_idx in ParalysisphasemanagerGlobal.soft_max_phases_by_night:
		soft_max = int(ParalysisphasemanagerGlobal.soft_max_phases_by_night[night_idx])

	var hard_max : int = -1
	if night_idx in ParalysisphasemanagerGlobal.hard_max_phases_by_night:
		hard_max = int(ParalysisphasemanagerGlobal.hard_max_phases_by_night[night_idx])

	var wake_chance : float = 100.0
	if night_idx in ParalysisphasemanagerGlobal.chance_to_wake_up_on_soft_max_by_night:
		wake_chance = float(ParalysisphasemanagerGlobal.chance_to_wake_up_on_soft_max_by_night[night_idx])

	# If we haven't reached the minimum required phases yet, continue immediately
	if completed_phases_count < min_phases:
		ParalysisphasemanagerGlobal.SWAP_PHASE(true)
		init_switch_countdown(night_idx)
		return

	# If we've hit or exceeded the hard max, force wake
	if hard_max != -1 and completed_phases_count >= hard_max:
		print("hard max phases reached -> forcing wake")
		emit_signal("wake_up")
		return

	# If we've reached or exceeded the soft max, roll to see if the night ends
	if soft_max != -1 and completed_phases_count >= soft_max:
		var roll := randf() * 100.0
		print("roll to end night: %f <= %f" % [roll, wake_chance])
		if roll <= wake_chance:
			# Night would end. roll again for a false reality. NOTE: there is no separate
			# false reality chance defined in the globals yet, so we reuse the same value
			var fr_roll := randf() * 100.0
			print("roll for false reality: %f <= %f" % [fr_roll, wake_chance])
			if fr_roll <= wake_chance:
				print("entering false reality")
				emit_signal("enter_false_reality")
				return
			else:
				print("waking up normally")
				emit_signal("wake_up")
				return
		# if the roll failed, continue the night unless we've hit the hard max
		else:
			if hard_max != -1 and completed_phases_count >= hard_max:
				print("hard max reached after failed roll -> forcing wake")
				emit_signal("wake_up")
				return
			# otherwise continue
			ParalysisphasemanagerGlobal.SWAP_PHASE(true)
			init_switch_countdown(night_idx)
			return

	# Default behaviour if no soft_max is defined: continue until hard max or externally stopped
	ParalysisphasemanagerGlobal.SWAP_PHASE(true)
	init_switch_countdown(night_idx)

func _process(_delta: float) -> void:
	if phase_switch_countdown_lbl == null or phase_switch_countdown == null:
		return
	phase_switch_countdown_lbl.text = LABEL_PREFIX + ("%.1f" % phase_switch_countdown.time_left)
