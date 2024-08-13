extends Node

const PLAYER_START_POS := Vector2(80, 80)
const CAM_START_POS := Vector2(138, 0)

var speed : float
const START_SPEED  := 4
const MAX_SPEED := 3.5
const SCORE_MODIFIER := 10
var screen_size : Vector2
var score : int
var game_running : bool


# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_window().size
	new_game()

func new_game():
	#pass
	$player.position = PLAYER_START_POS
	$player.velocity = Vector2(0, 0)
	$Camera.position = CAM_START_POS
	$Ground.position = Vector2(0, 0)
	$player.set_physics_process(false)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if game_running:
		
		$player.set_physics_process(true)
		
		speed = START_SPEED
		
		$player.position.x += speed
		$Camera.position.x += speed
		
		score += speed
		show_score()
		
		if $Camera.position.x - $Ground.position.x > screen_size.x * 1.5:
			$Ground.position.x += screen_size.x
	else:
		if Input.is_action_pressed("ui_accept"):
			game_running = true

func show_score():
	$HUD/ScoreLabel.text = "SCORE: " + str(score / SCORE_MODIFIER)
	$HUD/StartLabel.text = ""
	#$HUD/HighScoreLabel.text = "HIGHSCORE: " + str(score)
