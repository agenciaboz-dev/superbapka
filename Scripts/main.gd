extends Node

@onready var scenario_timer := $Scenario_timer as Timer
@onready var speed_up_timer := $Speed_up_timer as Timer
@onready var acceleration_timer := $Acceleration_timer as Timer
@onready var ground_array := [$Ground1, $Ground2, $Ground3] as Array[StaticBody2D]
@onready var player : CharacterBody2D
@onready var bg := $Bg as ParallaxBackground
@onready var fg := $Fg as ParallaxBackground
@onready var hud := $HUD as CanvasLayer
@onready var cam := $Camera as Camera2D
@onready var obst_spawner := $Obst_Spawner as Area2D
@onready var item_spawner := $Item_Spawner as Area2D 
@onready var npc_spawner := $Npc_Spawner as Area2D
@onready var despawner := $Despawner as Area2D

#constants
const PLAYER_START_POS := Vector2(125, 80)
const CAM_START_POS := Vector2(0, 0)
const START_SPEED  := 100
const MAX_SPEED := 400

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
var current_speed : float
var position : int
var tween : Tween
var acceleration : float
var is_player_dmg := false
var scenario_number := -1
var last_updated:= 0.0
var acceleration_count : float
var knockback_force := 0.0
var is_current_speed := false
var already_get_speed := false

#arrays
var ground_pieces = []
var obstacles : Array
var scenarios : Array[int]
var obstacle_path : Array[String]
var speed_target := 0

func _ready():
	Global.score = 0
	Global.collected_coins = 0
	Global.skin_id = randi_range(1 , 4)
	is_restart = false
	
	scenario_change()
	
	player = load("res://scenes/characters/ituzinho.tscn").instantiate()
	
	add_child(player)
	
	player.connect("is_damage", Callable(self, "on_have_damage"))
	
	Global.ground_width = ground_array[0].collision.properties.size.x
	ground_height = ground_array[0].collision.position.y
	screen_size = get_window().size
	ground_pieces = ground_array
	
	npc_spawner.set_path(["res://scenes/npc/npc.tscn"])
	
	order_by_position()
	new_game()

func new_game():
	for ground in ground_pieces:
		ground.transition_texture()
	
	speed_target = START_SPEED
	player.position = PLAYER_START_POS
	player.velocity = Vector2(0, 0)
	player.set_physics_process(false)
	Global.player_x = 0
	bg.sunshine.set_process(false)
	Global.game_running = false
	speed = 0

func _process(delta):
	if Input.is_action_just_pressed("ui_left"):
		print("skin_id: ", Global.skin_id)
		
	if Input.is_action_just_pressed("ui_right"):
		print("skin_id: ", Global.skin_id)
	
	if Input.is_action_just_pressed("ui_page_up"):
		scenario_number = Global.get_scenario_number()
		Global.scenario = scenario_number
		scenario_change()
	
	if Global.game_running:
		if not Global.is_alive:
			Global.game_running = false
		
		else:
			player.set_physics_process(true)
			
			control_speed(delta)
			
			camera_x = cam.position.x
			player.position.x += speed
			cam.position.x += speed
			despawner.position.x += speed
			obst_spawner.position.x += speed
			item_spawner.position.x += speed
			npc_spawner.position.x += speed
			
			Global.player_x = player.position.x
			Global.score += speed / 30
			
			if camera_x - ground_pieces[1].position.x > Global.ground_width:
				ground_pieces[0].position.x = ground_pieces[2].position.x + Global.ground_width
			
			order_by_position()
	
	else:
		bg.sunshine.set_process(false)
		
		if Input.is_action_just_pressed("ui_accept"):
			bg.sunshine.set_process(true)
			scenario_timer.start()
			speed_up_timer.start()
			acceleration_timer.start()
			Global.game_running = true
	
	is_restart = false

func control_speed(delta):
	knockback_force = -100 * delta
	current_speed = get_current_speed(delta)
	acceleration =  10 * delta

func toggle_pause():
	get_tree().paused = not get_tree().paused

func get_current_speed(delta):
	return speed_target * delta

func on_have_damage():
	is_player_dmg = true
	speed = knockback_force

func order_by_position():
	var n = ground_pieces.size()
	for i in range(n):
		for j in range(0, n - i - 1):
			if ground_pieces[j].position.x > ground_pieces[j + 1].position.x:
				var temp = ground_pieces[j]
				ground_pieces[j] = ground_pieces[j + 1]
				ground_pieces[j + 1] = temp
				ground_pieces[j + 1].transition_texture()

func scenario_change():
	scenario_number = Global.get_scenario_number()
	Global.scenario = scenario_number
	var texture_path = "res://assets/scenario/" + Global.get_scenario_name(Global.scenario)
	
	bg.get_scenario(Global.scenario)
	fg.get_scenario(Global.scenario)

func _on_hud_on_pause_action():
	toggle_pause()
	pass # Replace with function body.

func _on_acceleration_timer_timeout():
	if is_player_dmg:
		if player.is_on_floor():
			speed = 0
			is_player_dmg = false
	else:
		speed = move_toward(speed, current_speed, acceleration)
	pass # Replace with function body.

func _on_speed_up_timer_timeout():
	speed_target = move_toward(speed_target, MAX_SPEED, 50)
	pass # Replace with function body.

func _on_hud_on_restart_action():
	get_tree().reload_current_scene()
	pass # Replace with function body.

func _on_scenario_timer_timeout():
	scenario_number = Global.get_scenario_number()
	Global.scenario = scenario_number
	scenario_change()
	pass # Replace with function body.
