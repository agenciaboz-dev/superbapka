extends ParallaxBackground

const root_path := "res://assets/scenario/"

@export var sunshine : Sprite2D
@onready var bg_static := $"Static-bg" as Sprite2D
@onready var bg_array := [$acai, $paleta, $premium] as Array[ParallaxBackground]

var bg_current: ParallaxBackground
var bg_previous: ParallaxBackground

func get_scenario(id):
	var scenario_name = Global.get_scenario_name(id)
	bg_static.texture = load("res://assets/scenario/" + scenario_name + "/background.png")
	
	var new_bg = null
	for item in bg_array:
		if item.name == scenario_name:
			new_bg = item
			break
	
	if new_bg and new_bg != bg_current:
		bg_previous = bg_current
		bg_current = new_bg
		
		if not bg_previous:
			bg_current.first_scenario()
			return
		
		transition_bg()
	else:
		print("No change in background or invalid scenario name. - new_bg = ",  new_bg.name, " bg_current.name = ", bg_current.name)

func transition_bg():
	if bg_previous:
		bg_previous.fade_out()
	if bg_current:
		bg_current.visible = true
		bg_current.fade_in()
