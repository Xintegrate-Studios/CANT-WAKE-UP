extends Node3D

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
		if ParalysisphasemanagerGlobal.paralysis_phase == ParalysisphasemanagerGlobal.ParalysisPhase.ENCOUNTER:
			ParalysisphasemanagerGlobal.SWAP_PHASE()
		else:
			pass
