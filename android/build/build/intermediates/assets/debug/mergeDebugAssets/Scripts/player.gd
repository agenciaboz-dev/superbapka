extends CharacterBody2D

const GRAVITY : int = 1500
const JUMP_SPEED : int = -450
const INITIAL_HP : int =  100
const INITIAL_STATE : int = 3
const STATE_HP : int = 25
const MAX_HP : int = 125
const states = [
	{"const_hp": 0, "const_state": 0, "const_max_hp": false},
	{"const_hp": 25, "const_state": 1, "const_max_hp": false},
	{"const_hp": 50, "const_state": 2, "const_max_hp": false},
	{"const_hp": 75, "const_state": 3, "const_max_hp": false},
	{"const_hp": 100, "const_state": 4, "const_max_hp": false},
	{"const_hp": MAX_HP, "const_state": 4, "const_max_hp": true}
]
const skins = [{"id" : 1, "path" : "res://assets/characters/acai1.png"}, {"id" : 2, "path" : "res://assets/characters/acai2.png"}, {"id" : 3, "path" : "res://assets/characters/acai3.png"}, {"id" : 4, "path" : "res://assets/characters/acai4.png"}]

#var

@export var hp : float

#reiniciar o game (quando morre)
#trocar o estado do sprite

#var hp : float
var state : int
var previous_state := -320000
var freeze_input_jump := false
var is_alive := true
var animation_name : String

@onready var texture := $Animation as AnimatedSprite2D

func _ready():
	hp = INITIAL_HP
	state = INITIAL_STATE

func _physics_process(delta):
	if not is_alive:
		hp = 0
		animation_name = "s" + str(state) + "_hurt"
	else:
		hp -= delta
	velocity.y += GRAVITY * delta
	#freeze_input_jump = Input.is_action_just_released("ui_accept") and freeze_input_jump
	
	if Input.is_action_just_pressed("ui_down"):
		hp -= 10
	if Input.is_action_just_pressed("ui_up"):
		hp += 10
	get_all_stages()
	
	previous_state = state
	if is_alive:
		if is_on_floor():
			animation_name = "s" + str(state) + "_run"
			
			
			if Input.is_action_just_pressed("ui_accept"):
				velocity.y = JUMP_SPEED
				#freeze_input_jump = true
		else:
			animation_name = "s" + str(state) + "_jump"
	
	else:
		animation_name = "s0"
	
	texture.play(animation_name)
	move_and_slide()
	
func get_all_stages():
#	for item in states:
#		if hp <= item["const_state"]:
#			state = item["const_state"]
#			if item["const_max_hp"]:
#				hp = MAX_HP
#			break

	#moreninha derreterá mais rápido conforme colide com obstáculos, alterando o multiplicador de hp drop, continuando assim, até o final do jogo
	#até então, ela é ÚNICA no jogo com essa feature

	if hp <= 0:
		state = 0
		is_alive = false
	elif hp <= 25:
		state = 1
	elif hp <= 50:
		state = 2
	elif hp <= 75:
		state = 3
	elif hp <= 100:
		state = 4
	elif hp >= MAX_HP:
		state = 5
		hp = MAX_HP
	
	print("hp: ", hp, " state: ", state)

func is_player_dead():
	var is_dead = not is_alive
	return is_dead
