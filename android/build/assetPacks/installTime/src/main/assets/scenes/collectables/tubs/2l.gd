extends Area2D

@onready var animation := $Animation as AnimatedSprite2D
@export var type := "heal2"

func _ready():
	animation.play(str(randi_range(1, 4)))


func _on_body_entered(body):
	Global.player_heal = 20
	self.queue_free()
	#has_obst = true
	pass # Replace with function body.
