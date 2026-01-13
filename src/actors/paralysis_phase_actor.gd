extends Node3D

@export var phase_switch_countdown : Timer

func init_switch_countdown(night_idx : int):
	phase_switch_countdown.wait_time
	phase_switch_countdown.start()

func START_PHASES() -> void:
	if NightmanagerGlobal.NIGHT_IDX == 1:
		ParalysisphasemanagerGlobal.SWAP_PHASE(false, ParalysisphasemanagerGlobal.ParalysisPhase.NORMAL)
		print("now on phase: " + str(ParalysisphasemanagerGlobal.paralysis_phase))
		# do preset
	else:
		# else do random
		pass

func _on_phase_switch_countdown_timeout() -> void:
	if NightmanagerGlobal.NIGHT_IDX == 1:
		if ParalysisphasemanagerGlobal.paralysis_phase != ParalysisphasemanagerGlobal.ParalysisPhase.REALITYDISTORTION:
			if ParalysisphasemanagerGlobal.paralysis_phase == ParalysisphasemanagerGlobal.ParalysisPhase.ENCOUNTER:
				ParalysisphasemanagerGlobal.SWAP_PHASE(false, ParalysisphasemanagerGlobal.ParalysisPhase.REALITYDISTORTION)
				print("now on phase: " + str(ParalysisphasemanagerGlobal.paralysis_phase))
			else:
				ParalysisphasemanagerGlobal.SWAP_PHASE(false, ParalysisphasemanagerGlobal.ParalysisPhase.ENCOUNTER)
				print("now on phase: " + str(ParalysisphasemanagerGlobal.paralysis_phase))
		else:
			print("DONE")
