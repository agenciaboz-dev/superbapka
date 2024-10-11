extends ParallaxBackground

signal fade_in_call
signal fade_out_call
signal first_scenario_call

var children_array: Array = []

func fade_in():
	fade_in_call.emit()

func fade_out():
	fade_out_call.emit()

func first_scenario():
	first_scenario_call.emit()
