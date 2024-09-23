extends ParallaxBackground

const root_path := "res://assets/scenario/"

@export var sunshine : Sprite2D
@onready var bg_array := [$acai, $paleta, $premium] as Array[ParallaxBackground]


func get_scenario(id):
	for item in bg_array:
		item.visible = false
		if item.name == Global.get_scenario_name(id):
			item.visible = true
		
	pass
