extends Area2D

@onready var animation := $Animation as AnimatedSprite2D

func _ready():
	animation.play(str(randi_range(1, 8)))
