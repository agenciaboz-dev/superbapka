extends StaticBody2D

@onready var collision := $Collision as CollisionShape2D
@onready var ground_sprite := $Ground_Sprite as Sprite2D

func get_width():
	return collision.size.x

func transition_texture():
	if Global.is_transitioning and Global.previous_scenario:
		ground_sprite.texture = load("res://assets/scenario/transition/" + Global.get_previous_and_current() + ".png")
		Global.is_transitioning = false
	else:
		ground_sprite.texture = load("res://assets/scenario/" + Global.get_scenario_name(Global.scenario) + "/layer3-0.png")
