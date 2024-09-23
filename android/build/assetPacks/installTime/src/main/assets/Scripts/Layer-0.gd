extends ParallaxLayer

@export var screen_height : float

func _ready():
	screen_height = get_viewport().size.y
	#motion_mirroring = Vector2(screen_height *1.5, 0)
