extends RunnerRoom

var max_runs = 5
var runs = 0

func is_finished():
	runs = runs + 1

	return runs >= max_runs
