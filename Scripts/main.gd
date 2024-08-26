extends Node

#instancied objects
@export var timer : Timer
@export var ground_array : Array[StaticBody2D]
@export var player : CharacterBody2D
@export var bg : ParallaxBackground
@export var hud : CanvasLayer
@export var cam : Camera2D

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

#arrays
var ground_pieces = []
var obstacles : Array
var scenarios : Array[int]
var obstacle_path : Array[String]

func _ready():
	timer.start()
	
	obstacle_path = ["res://scenes/acai/3.tscn", "res://scenes/acai/2.tscn", "res://scenes/acai/1.tscn"]
	
	ground_width = ground_array[0].collision.properties.size.x
	ground_height = ground_array[0].ground_texture.texture.get_height()
	screen_size = get_window().size
	ground_pieces = ground_array
	
	order_by_position()
	new_game()

func new_game():
	player.position = PLAYER_START_POS
	player.velocity = Vector2(0, 0)
	player.set_physics_process(false)
	bg.sunshine.set_process(false)
	
func _process(delta):
	if game_running:
		player.set_physics_process(true)
		
		generate_obstacles()
		
		camera_x = cam.position.x
		speed = START_SPEED * delta
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
	
	
func generate_obstacles():
	#generate ground obstacles
	if obstacles.is_empty() or last_obst.position.x < score + randi_range(0,50):
		var max_obst = 3
		var obst
		
		for i in range(randi() %  max_obst + 1):
			var obstacle_object = load(obstacle_path[randi() % obstacle_path.size()])
			var last_obst_height : float
			
			obst = obstacle_object.instantiate()
			
			var obst_size = obst.get_node("Sprite2D").texture.get_size()
			var obst_scale = obst.get_node("Sprite2D").scale
			var obst_x : int = screen_size.x + score + 200
			var obst_y : int = screen_size.y - ground_height - (obst_size.x * obst_scale.y /2) +25
			
			print("size: ", obst_size)
			print("scale: ", obst_scale)
			if i == 0:
				obst_x += i * 500
			else:
				obst_x += last_obst_height + (i * 30)
			
			last_obst = obst
			
			last_obst_height = obst_size.x
			
			add_obs(obst, obst_x, obst_y)
		

func add_obs(obst, x, y):
	obst.position = Vector2i(x, y)
	add_child(obst)
	obstacles.append(obst)

func order_by_position():
	var n = ground_pieces.size()
	for i in range(n):
		for j in range(0, n - i - 1):
			if ground_pieces[j].position.x > ground_pieces[j + 1].position.x:
				var temp = ground_pieces[j]
				ground_pieces[j] = ground_pieces[j + 1]
				ground_pieces[j + 1] = temp

func _on_timer_timeout():
	#print(obst_name)
	print(get_window().size)
