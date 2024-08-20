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
var collision_size : Vector2 
var middle_screen : float
var ground_width : float
var right_edge_of_ground : float
var right_edge_of_screen : float
var ground_pieces = []
var active_pieces = []
var max_x := -1e10
var camera_x : float


# Called when the node enters the scene tree for the first time.
func _ready():
	#OS.window_size = Vector2(320, 200)  # Força a janela a ter um tamanho específico
	#get_tree().set_screen_stretch(SceneTree.StretchMode.VIEWPORT, SceneTree.StretchAspect.KEEP, Vector2(320, 200))
	$Timer.start()
	ground_width = $Ground1/Collision.properties.size.x
	screen_size = get_window().size
	
	ground_pieces = [$Ground3, $Ground1, $Ground2]
	
	order_by_position()
	
	middle_screen = screen_size.x / 2
	new_game()
	
func new_game():
	#pass
	$player.position = PLAYER_START_POS
	$player.velocity = Vector2(0, 0)
	$Camera.position = CAM_START_POS
	#$Ground1.position = Vector2(0, 0)
	$player.set_physics_process(false)
	$Bg/Sunshine.set_process(false)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if game_running:
		$player.set_physics_process(true)
		
		camera_x = $Camera.position.x
		var screen_right_edge = camera_x + screen_size.x / 2
		
		speed = START_SPEED
		
		$player.position.x += speed
		$Camera.position.x += speed
		
		score += speed
		show_score()
		
		if camera_x - ground_pieces[1].position.x > ground_width:
			ground_pieces[0].position.x = ground_pieces[2].position.x + ground_width
		
		order_by_position()
		
		
	else:
		if Input.is_action_pressed("ui_accept"):
			$Bg/Sunshine.set_process(true)
			game_running = true

func show_score():
	$HUD/ScoreLabel.text = "SCORE: " + str(score / SCORE_MODIFIER)
	$HUD/StartLabel.visible_characters = 0
	#$HUD/HighScoreLabel.text = "HIGHSCORE: " + str(score)

func order_by_position():
	# Uma implementação simples de ordenação por bolha
	var n = ground_pieces.size()
	for i in range(n):
		for j in range(0, n - i - 1):
			if ground_pieces[j].position.x > ground_pieces[j + 1].position.x:
				# Trocar os pedaços de chão usando uma variável temporária
				var temp = ground_pieces[j]
				ground_pieces[j] = ground_pieces[j + 1]
				ground_pieces[j + 1] = temp

func _on_timer_timeout():
	var i=0
	for piece in ground_pieces:
		i += 1
		print(i, " ",piece.name, " ", piece.position.x)
