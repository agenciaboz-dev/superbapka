extends Node

const PLAYER_START_POS := Vector2(80, 80)
const CAM_START_POS := Vector2(138, 0)

var speed : float
const START_SPEED : float = 1.5
const MAX_SPEED : int = 3
var screen_size : Vector2 

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_window().size
	new_game()
	#pass # Replace with function body.

func new_game():
	#pass
	$player.position = PLAYER_START_POS
	$player.velocity = Vector2(0, 0)
	$Camera.position = CAM_START_POS
	$Ground.position = Vector2(0, 0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#pass
	speed = START_SPEED
	
	$player.position.x += speed
	$Camera.position.x += speed
	
	if $Camera.position.x - $Ground.position.x > screen_size.x * 1.5:
		$Ground.position.x += screen_size.x
