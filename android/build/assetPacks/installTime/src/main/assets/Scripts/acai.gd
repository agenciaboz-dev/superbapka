extends CharacterBody2D

const GRAVITY : int = 1500
const JUMP_SPEED : int = -450
const INITIAL_HP : int =  100
const INITIAL_STATE : int = 3
const STATE_HP : int = 25
const MAX_HP : int = 100
const MAX_OVERHP := 125
const states = [
	{"const_hp": 0, "const_state": 0, "const_max_hp": false},
	{"const_hp": 25, "const_state": 1, "const_max_hp": false},
	{"const_hp": 50, "const_state": 2, "const_max_hp": false},
	{"const_hp": 75, "const_state": 3, "const_max_hp": false},
	{"const_hp": 100, "const_state": 4, "const_max_hp": false},
	{"const_hp": MAX_HP, "const_state": 4, "const_max_hp": true}
	]

@onready var texture : AnimatedSprite2D

#var
@export var hp : float

#var hp : float
var state : int
var previous_state := -320000
var freeze_input_jump := false
var animation_name : String
var mark_overheal := false
var skinid := 0


func _ready():
	#print(skins)
	#apply_skin()
	apply_skin()
	Global.is_overheal = false
	Global.is_alive = true
	hp = INITIAL_HP
	state = INITIAL_STATE

func _physics_process(delta):
	
	if not Global.is_alive:
		hp = 0
		animation_name = "s" + str(state) + "_hurt"
	else:
		hp -= delta
	velocity.y += GRAVITY * delta
	
	if Global.call_dmg:
		get_dmg()
	
	if Global.player_heal > 0:
		heal()
	#freeze_input_jump = Input.is_action_just_released("ui_accept") and freeze_input_jump
	
	if Input.is_action_just_pressed("ui_down"):
		get_dmg()
	if Input.is_action_just_pressed("ui_up"):
		Global.player_heal = 25
	get_all_stages()
	
	previous_state = state
	if Global.is_alive and not Global.call_dmg:
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
	if skinid != Global.skin_id:
		apply_skin()
	
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
		Global.is_alive = false
			
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
	
	#print("hp: ", hp, " state: ", state)

func is_player_dead():
	var is_dead = not Global.is_alive
	return is_dead

func get_dmg():
	animation_name = "s" + str(state) + "_hurt"
	hp -= 25
	print("dmg")
	Global.call_dmg = false

func heal():
	if Global.is_overheal:
		mark_overheal = true
		if (hp + Global.player_heal) > MAX_OVERHP:
			hp = MAX_OVERHP
		else:
			hp += Global.player_heal
	else:
		if not mark_overheal:
			if hp > MAX_HP:
				hp = MAX_HP
			else:
				hp += Global.player_heal
	
	if mark_overheal and hp < MAX_HP:
		mark_overheal = false
	
	print("heal: ", Global.player_heal)
	Global.player_heal = 0
	Global.is_overheal = false

func apply_skin():
	if texture:
	texture.visible = false
	
	skinid = Global.skin_id
	
	if skinid == 1:
		texture = $Skin_default
	elif skinid == 2:
		texture = $Skin_recolor
	elif skinid == 3:
		texture = $Skin_recolor2
	elif skinid == 4:
		texture = $Skin_recolor3
	
	texture.visible = true
	
#	if texture:
#		texture.visible = false
#	
#	texture = skins[Global.skin_id]
#	texture.visible = true
#	print("Texture set to:", skins[Global.skin_id].name)
#	skinid = Global.skin_id
	pass

func _on_hitbox_body_entered(body):
	print(body.name)
	#Global.player_heal = 25
	#has_obst = true
	pass # Replace with function body.
