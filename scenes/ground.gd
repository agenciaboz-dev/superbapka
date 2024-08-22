extends StaticBody2D

@export var collision : CollisionShape2D

func _ready():
	collision = $Collision
