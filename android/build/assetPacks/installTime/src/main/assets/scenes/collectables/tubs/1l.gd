extends Area2D

signal on_1l_collect(heal_value)

@onready var animation := $Animation as AnimatedSprite2D

func _ready():
	animation.play(str(randi_range(1, 8)))

func _on_body_entered(body):
	if body.is_in_group("players"):
		body.heal(10)
	
	self.queue_free()
	pass # Replace with function body.
