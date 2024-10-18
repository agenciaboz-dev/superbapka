extends ParallaxBackground

const root_path := "res://assets/scenario/"

@onready var fg_array := [$acai, $paleta, $premium] as Array[ParallaxLayer]

var fg_current : ParallaxLayer
var fg_previous : ParallaxLayer
var tween_in : Tween
var tween_out : Tween

func _ready():
	for item in fg_array:
		item.modulate.a = 0


func get_scenario(id):
	var new_fg = null
	
	for item in fg_array:
		if item.name == Global.get_scenario_name(id):
			item.visible = true
			new_fg = item
	
	if new_fg and new_fg != fg_current:
		fg_previous = fg_current
		fg_current = new_fg
		
		transition_fg()

func transition_fg():
	tween_in = create_tween()
	tween_out = create_tween()
	
	if fg_previous:
		fade_out()
	if fg_current:
		fade_in()
	
	await tween_out.finished
	fg_previous.visible = false

func fade_in():
	var tween = create_tween()
	fg_current.visible = true
	if Global.previous_scenario:
		tween.tween_property(fg_current, "modulate:a", 1, 15)
	else:
		fg_current.modulate.a = 1
	
func fade_out():
	var tween = create_tween()
	
	tween.tween_property(fg_previous, "modulate:a", 0, 2)
	
	await tween.finished
	fg_previous.visible = false
