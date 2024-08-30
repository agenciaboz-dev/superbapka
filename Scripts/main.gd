extends Node

#instancied objects
@export var timer : Timer
@export var ground_array : Array[StaticBody2D]
@export var player : CharacterBody2D
@export var bg : ParallaxBackground
@export var hud : CanvasLayer
@export var cam : Camera2D
@export var obst_spawner : Node2D

#constants
const PLAYER_START_POS := Vector2(125, 80)
const CAM_START_POS := Vector2(0, 0)
const START_SPEED  := 300
const MAX_SPEED := 350
const SCORE_MODIFIER := 10

#variables
var speed : float
var screen_size : Vector2
var score : int
var game_running : bool
var middle_screen : float
var ground_width : float
var camera_x : float
var ground_height : int
var last_obst
var obst_name : String
var spawn_distance: float
var last_obst_position := 0.0
var obst_spawner_pos : Vector2

#arrays
var ground_pieces = []
var obstacles : Array
var scenarios : Array[int]
var obstacle_path : Array[String]

func _ready():
	timer.start()
	
	ground_width = ground_array[0].collision.properties.size.x
	ground_height = ground_array[0].collision.position.y
	screen_size = get_window().size
	ground_pieces = ground_array
	
	obst_spawner.set_path(["res://scenes/acai/3.tscn", "res://scenes/acai/2.tscn", "res://scenes/acai/1.tscn"])
	
	order_by_position()
	new_game()

func new_game():
	player.position = PLAYER_START_POS
	player.velocity = Vector2(0, 0)
	player.set_physics_process(false)
	bg.sunshine.set_process(false)
	game_running = false
	speed = 0
	
func _process(delta):
	if game_running:
		if player.is_player_dead():
			game_running = false
			if Input.is_action_pressed("ui_accept"):
				get_tree().reload_current_scene()
		else:
			player.set_physics_process(true)
			
			camera_x = cam.position.x
			speed = START_SPEED * delta
			player.position.x += speed
			cam.position.x += speed
			obst_spawner.position.x += speed
			score += speed
			
			show_score()
			
			if camera_x - ground_pieces[1].position.x > ground_width:
				ground_pieces[0].position.x = ground_pieces[2].position.x + ground_width
			
			order_by_position()
			
	else:
		if Input.is_action_just_pressed("ui_accept"):
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
	#print("ssize: ",screen_size)
	#print("spawner.position: ",obst_spawner.position)
	pass
