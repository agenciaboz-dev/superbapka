extends ParallaxBackground

const root_path := "res://assets/scenario/"

@export var sunshine : Sprite2D
@onready var bg_static := $"Static-bg" as Sprite2D
@onready var bg_array := [$acai, $paleta, $premium] as Array[ParallaxBackground]

func get_scenario(id):
	var scenario_name = Global.get_scenario_name(id)
	bg_static.texture = load("res://assets/scenario/" + scenario_name + "/background.png")
	
	for item in bg_array:
		item.visible = false
		if item.name == scenario_name:
			item.visible = true
	
	pass
