extends Node

enum ParalysisPhase { NORMAL, ENCOUNTER, REALITYDISTORTION }
const PHASE_COUNT : int = int(ParalysisPhase.REALITYDISTORTION) + 1
var paralysis_phase : ParalysisPhase = ParalysisPhase.NORMAL

# as a percentage
var chance_to_wake_up_on_soft_max_by_night : Dictionary = {
	1: 100.0,
	2: 90.0,
	3: 85.0,
}

# absolute minimum phases for each night (night 1 is always hard locked at 3 phases)
var min_phases_by_night : Dictionary = {
	1: 3,
	2: 3,
}

# minimum max phases for each night, after this phase count the
# chance_to_wake_up_on_soft_max_by_night can be used to determine
# whether the player stays or wakes up, every time the player switches phases.
# if the chance is a success, the player wakes up. if not, the player
# stays in the phase cycle until the hard max phase threshold is hit (below)
var soft_max_phases_by_night : Dictionary = {
	1: 4,
	2: 4,
}

# absolute max phases for each night. the player CAN NOT have any more phases in a night
# than the value here. for example, if the player is on phase 4 (whatever it may be, normal,
# an encounter or a reality distortion, and the hard max is 5 phases in that night,
# and they complete the phase, they must complete 1 more (5 phases total) before waking up,
# but that assumes the chance to wake up on the soft max wasnt successfull.
var hard_max_phases_by_night : Dictionary = {
	1: 3,
	2: 5,
}

# [min, max] sec
var phase_length_bounds_by_night : Dictionary = {
	1: [10.0, 20.0],
	# TODO: ADD MORE
}

# adjust each to whatever, they are ratios anyway
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
