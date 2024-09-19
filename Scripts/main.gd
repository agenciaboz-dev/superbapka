extends Node

#instancied objects
@onready var timer := $Timer as Timer
@onready var ground_array := [$Ground1, $Ground2, $Ground3] as Array[StaticBody2D]
@onready var player : CharacterBody2D
@onready var bg := $Bg as ParallaxBackground
@onready var hud := $HUD as CanvasLayer
@onready var cam := $Camera as Camera2D
@onready var obst_spawner := $Obst_Spawner as Area2D
@onready var item_spawner := $Item_Spawner as Area2D 
@onready var npc_spawner := $Npc_Spawner as Area2D
@onready var jump_btn := $HUD/Controls/Jump_button as TouchScreenButton
@onready var pause_btn := $HUD/Controls/pause_button as TouchScreenButton
@onready var unpause_btn := $HUD/Controls/unpause_button as TouchScreenButton

#constants
const PLAYER_START_POS := Vector2(125, 80)
const CAM_START_POS := Vector2(0, 0)
const START_SPEED  := 250
const MAX_SPEED := 300

#variables
var speed : float
var screen_size : Vector2
var camera_x : float
var ground_height : int
var last_obst
var obst_name : String
var spawn_distance: float
var last_obst_position := 0.0
var obst_spawner_pos : Vector2
var is_restart : bool
var current_speed : int
var position : int
var tween : Tween
var acceleration : float
var is_player_dmg := false

#arrays
var ground_pieces = []
var obstacles : Array
var scenarios : Array[int]
var obstacle_path : Array[String]

func _ready():
	timer.start()
	
	Global.start_msg = "Toque para iniciar"
	Global.score = 0
	Global.collected_coins = 0
	Global.skin_id = 3
	is_restart = false
	
	player = load("res://scenes/characters/ituzinho.tscn").instantiate()
	
	add_child(player)
	
	player.connect("is_damage", Callable(self, "on_have_damage"))
	
	Global.ground_width = ground_array[0].collision.properties.size.x
	ground_height = ground_array[0].collision.position.y
	screen_size = get_window().size
	ground_pieces = ground_array
	
	obst_spawner.set_path(["res://scenes/acai/3.tscn", "res://scenes/acai/2.tscn", "res://scenes/acai/1.tscn"])
	item_spawner.set_path(["res://scenes/collectables/tubs/1l.tscn", "res://scenes/collectables/tubs/2l.tscn", "res://scenes/collectables/tubs/premium.tscn"])
	npc_spawner.set_path(["res://scenes/npc/npc.tscn"])
	
	order_by_position()
	new_game()

func new_game():
	current_speed = START_SPEED
	player.position = PLAYER_START_POS
	player.velocity = Vector2(0, 0)
	player.set_physics_process(false)
	Global.player_x = 0
	bg.sunshine.set_process(false)
	Global.game_running = false
	speed = 0

func _process(delta):
	if Input.is_action_just_pressed("ui_left"):
		Global.skin_id +=1
		print("skin_id: ", Global.skin_id)
	if Input.is_action_just_pressed("ui_right"):
		Global.skin_id -=1
		print("skin_id: ", Global.skin_id)
	
	if Global.game_running:
		
		if not Global.is_alive:
			Global.start_msg = "Toque para reiniciar"
			Global.game_running = false
			if Input.is_action_pressed("ui_accept"):
				get_tree().reload_current_scene()
		else:
			Global.start_msg = ""
			player.set_physics_process(true)
			
			control_speed()
			
			camera_x = cam.position.x
			player.position.x += speed
			cam.position.x += speed
			obst_spawner.position.x += speed
			item_spawner.position.x += speed
			npc_spawner.position.x += speed
			Global.player_x = player.position.x
			
			Global.score += speed / 30
			
			if camera_x - ground_pieces[1].position.x > Global.ground_width:
				ground_pieces[0].position.x = ground_pieces[2].position.x + Global.ground_width
			
			order_by_position()

	else:
		if Input.is_action_just_pressed("ui_accept"):
			bg.sunshine.set_process(true)
			Global.game_running = true
	
	is_restart = false

func control_speed():
	acceleration = get_process_delta_time() * 0.05
	if Global.call_dmg:
		pass
	
	if player.is_on_floor():
		if is_player_dmg:
			speed = 0
			is_player_dmg = false
		else:
			speed += acceleration
	
	if speed < current_speed * get_process_delta_time():
		speed += acceleration
	else:
		speed = current_speed * get_process_delta_time()

func toggle_pause():
	get_tree().paused = not get_tree().paused

func on_have_damage():
	is_player_dmg = true
	speed = current_speed * get_process_delta_time() * -1

func order_by_position():
	var n = ground_pieces.size()
	for i in range(n):
		for j in range(0, n - i - 1):
			if ground_pieces[j].position.x > ground_pieces[j + 1].position.x:
				var temp = ground_pieces[j]
				ground_pieces[j] = ground_pieces[j + 1]
				ground_pieces[j + 1] = temp

func _on_timer_timeout():
	pass

func _on_hud_on_pause_action():
	toggle_pause()
	pass # Replace with function body.
