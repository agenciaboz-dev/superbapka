extends ParallaxBackground

const root_path := "res://assets/scenario/"

@onready var fg_array := [$acai, $paleta, $premium] as Array[ParallaxLayer]

func get_scenario(id):
	for item in fg_array:
		item.visible = false
		if item.name == Global.get_scenario_name(id):
			item.visible = true
	pass
