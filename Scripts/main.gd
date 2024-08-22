extends Node

@export var timer : Timer
@export var ground_array : Array[StaticBody2D]
@export var player : CharacterBody2D
@export var bg : ParallaxBackground
@export var hud : CanvasLayer
@export var cam : Camera2D

const PLAYER_START_POS := Vector2(125, 80)
const CAM_START_POS := Vector2(0, 0)

var speed : float
const START_SPEED  := 4
const MAX_SPEED := 3.5
const SCORE_MODIFIER := 10
var screen_size : Vector2
var score : int
var game_running : bool
var middle_screen : float
var ground_width : float
var ground_pieces = []
var camera_x : float

func _ready():
	timer.start()
	ground_width = ground_array[0].collision.properties.size.x
	screen_size = get_window().size
	ground_pieces = ground_array
	
	order_by_position()
	
	middle_screen = screen_size.x / 2
	
	new_game()
	
func new_game():
	player.position = PLAYER_START_POS
	player.velocity = Vector2(0, 0)
	player.set_physics_process(false)
	bg.sunshine.set_process(false)
	
func _process(delta):
	if game_running:
		player.set_physics_process(true)
		
		camera_x = cam.position.x
		speed = START_SPEED
		player.position.x += speed
		cam.position.x += speed
		score += speed
		
		
		show_score()
		
		if camera_x - ground_pieces[1].position.x > ground_width:
			ground_pieces[0].position.x = ground_pieces[2].position.x + ground_width
		
		order_by_position()
		
	else:
		if Input.is_action_pressed("ui_accept"):
			bg.sunshine.set_process(true)
			game_running = true

func show_score():
	hud.score = score / SCORE_MODIFIER
	hud.started = true
	#$hud.high_score_label.text = score

func order_by_position():
	var n = ground_pieces.size()
	for i in range(n):
		for j in range(0, n - i - 1):
			if ground_pieces[j].position.x > ground_pieces[j + 1].position.x:
				var temp = ground_pieces[j]
				ground_pieces[j] = ground_pieces[j + 1]
				ground_pieces[j + 1] = temp

func _on_timer_timeout():
	print("player: ", player.position)
	#print(get_window().size)
