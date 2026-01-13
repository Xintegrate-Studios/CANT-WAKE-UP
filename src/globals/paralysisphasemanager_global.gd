extends Node

enum ParalysisPhase { NORMAL, ENCOUNTER, REALITYDISTORTION }
const PHASE_COUNT : int = int(ParalysisPhase.REALITYDISTORTION) + 1
var paralysis_phase : ParalysisPhase = ParalysisPhase.NORMAL

# [min, max] sec
var phase_length_bounds_by_night : Dictionary = {
	1: [10.0, 20.0],
	# TODO: ADD MORE
}

var phase_weights_by_night : Dictionary = {
	1: [1, 1, 1],
	2: [1, 1, 1],
	3: [1, 1, 1],
	4: [1, 1, 1],
	# TODO: ADD MORE
}

var phase_weights : Array = [1, 1, 1]

func set_phase_weights_by_night(night_idx : int):
	phase_weights = phase_weights_by_night[night_idx]

func set_phase_weights(weights: Array) -> void:
	if weights.size() != PHASE_COUNT:
		push_error("set_phase_weights: weights length must match PHASE_COUNT (%d)" % PHASE_COUNT)
		return
	phase_weights = []
	for w in weights:
		phase_weights.append(float(w))

func get_random_phase_length(night_idx: int) -> float:
	if night_idx not in phase_length_bounds_by_night:
		push_error("get_random_phase_length: night %d not found in phase_length_bounds_by_night" % night_idx)
		return 0.0
	var bounds = phase_length_bounds_by_night[night_idx]
	return randf_range(bounds[0], bounds[1])

func SWAP_PHASE(random: bool = true, new_phase: ParalysisPhase = ParalysisPhase.NORMAL) -> String:
	if random:
		var weights := phase_weights
		if weights.size() != PHASE_COUNT:
			weights = []
			for i in range(PHASE_COUNT):
				weights.append(1.0)
		var total := 0.0
		for w in weights:
			total += float(w)
		if total <= 0.0:
			paralysis_phase = ParalysisPhase.NORMAL
			return "NORMAL"
		var pick := randf() * total
		var cumulative := 0.0
		for i in range(weights.size()):
			cumulative += float(weights[i])
			if pick <= cumulative:
				paralysis_phase = i as ParalysisPhase
				return str(paralysis_phase)
	else:
		paralysis_phase = new_phase
		return str(paralysis_phase)
	
	# fallback return to satisfy the compiler
	return str(paralysis_phase)
