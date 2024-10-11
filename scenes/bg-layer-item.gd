extends ParallaxLayer

var parent

func _ready():
	modulate.a = 0
	parent = get_parent()
	
	parent.connect("fade_in_call", Callable(self, "on_fade_in"))
	parent.connect("fade_out_call", Callable(self, "on_fade_out"))
	parent.connect("first_scenario_call", Callable(self, "on_first_scenario_call"))

func on_first_scenario_call():
	parent.visible = true
	modulate.a = 1

func on_fade_in():
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 1, 1)
	

func on_fade_out():
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0, 1)
	await tween.finished
	parent.visible = false
