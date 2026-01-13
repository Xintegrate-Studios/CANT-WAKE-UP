extends Node3D

@export var phase_switch_countdown : Timer
@export var phase_switch_countdown_lbl : Label

func init_switch_countdown(night_idx : int):
	phase_switch_countdown.wait_time = ParalysisphasemanagerGlobal.get_random_phase_length(night_idx)
	phase_switch_countdown.start()

func START_PHASES() -> void:
	init_switch_countdown(NightmanagerGlobal.NIGHT_IDX)
	if NightmanagerGlobal.NIGHT_IDX == 1:
		ParalysisphasemanagerGlobal.SWAP_PHASE(false, ParalysisphasemanagerGlobal.ParalysisPhase.NORMAL)
		print("now on phase: " + str(ParalysisphasemanagerGlobal.paralysis_phase))
		# do preset
	else:
		# else do random
		pass

func _on_phase_switch_countdown_timeout() -> void:
	if NightmanagerGlobal.NIGHT_IDX == 1:
		print("phase before: " + str(ParalysisphasemanagerGlobal.paralysis_phase))
		if ParalysisphasemanagerGlobal.paralysis_phase != ParalysisphasemanagerGlobal.ParalysisPhase.REALITYDISTORTION:
			init_switch_countdown(NightmanagerGlobal.NIGHT_IDX)
			if ParalysisphasemanagerGlobal.paralysis_phase == ParalysisphasemanagerGlobal.ParalysisPhase.ENCOUNTER:
				ParalysisphasemanagerGlobal.SWAP_PHASE(false, ParalysisphasemanagerGlobal.ParalysisPhase.REALITYDISTORTION)
				print("now on phase: " + str(ParalysisphasemanagerGlobal.paralysis_phase))
			else:
				ParalysisphasemanagerGlobal.SWAP_PHASE(false, ParalysisphasemanagerGlobal.ParalysisPhase.ENCOUNTER)
				print("now on phase: " + str(ParalysisphasemanagerGlobal.paralysis_phase))
		else:
			print("DONE")

func _process(_delta: float) -> void:
	phase_switch_countdown_lbl.text = "PHASE SWITCH: " + str(phase_switch_countdown.time_left)
