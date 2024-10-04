extends Area2D

@export var texture_size : Vector2

func _ready():
	texture_size = $Sprite2D.texture.get_size()


func _on_body_entered(body):
	Global.call_dmg = true
	pass # Replace with function body.
