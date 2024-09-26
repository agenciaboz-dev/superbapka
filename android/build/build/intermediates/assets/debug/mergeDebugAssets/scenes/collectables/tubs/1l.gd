extends Area2D

@onready var animation := $Animation as AnimatedSprite2D
@export var type := "heal"

func _ready():
	animation.play(str(randi_range(1, 8)))

func _on_body_entered(body):
	Global.player_heal = 10
	
	self.queue_free()
	#has_obst = true
	pass # Replace with function body.
