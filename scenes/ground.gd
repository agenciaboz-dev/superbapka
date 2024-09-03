extends StaticBody2D

@onready var collision := $Collision as CollisionShape2D
@onready var ground_texture := $Ground_Texture as Sprite2D

func get_width():
	return collision.size.x
