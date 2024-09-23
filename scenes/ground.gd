extends StaticBody2D

@onready var collision := $Collision as CollisionShape2D
@onready var ground_sprite := $Ground_Sprite as Sprite2D


func get_width():
	return collision.size.x

func transition_texture(texture_path):
	ground_sprite.texture = load(texture_path + "/layer3-0.png")
