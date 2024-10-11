extends Sprite2D

var rotation_speed := 0.05

func _ready():
	pass

func _process(delta):
	rotation += rotation_speed * delta
