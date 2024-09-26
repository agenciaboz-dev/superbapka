extends CharacterBody2D

signal is_damage

@onready var timer := $Timer as Timer
@onready var jump_sfx := $jump_sfx as AudioStreamPlayer
@onready var dead_sfx := $dead_sfx as AudioStreamPlayer
@onready var heal_sfx := $heal_sfx as AudioStreamPlayer

const GRAVITY : int = 1500
const JUMP_SPEED : int = -450
const INITIAL_HP : int =  100
const INITIAL_STATE : int = 3
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
var animation_name : String
var mark_overheal := false
var skinid := 0
var is_jump := false
var is_damage_boost := false
var is_on_ground := false
var is_knockback := false
var is_timer_stop := false
var audio_played := false

func _ready():
	apply_skin()
	Global.is_overheal = false
	Global.is_alive = true
	hp = INITIAL_HP
	state = INITIAL_STATE
	

func _physics_process(delta):
	is_on_ground = is_on_floor()

	if not Global.is_alive:
		if not audio_played:
			dead_sfx.play()
			audio_played = true
		hp = 0
		animation_name = "s0"
	else:
		hp -= delta
	
	velocity.y += GRAVITY * delta
	
	if is_knockback:
		if is_on_ground:
			hp -= 25
			is_knockback = false
	
	if Global.player_heal > 0:
		heal()
	
	# Apenas permite que o personagem tome dano se o damage boost não estiver ativo
	if is_damage_boost:
		Global.call_dmg = false
	else:
		if Input.is_action_just_pressed("ui_down") or Global.call_dmg:
			get_dmg()

	if Input.is_action_just_pressed("ui_up"):
		Global.player_heal = 25
	
	get_all_stages()
	
	if Input.is_action_just_pressed("ui_accept"):
		is_jump = true
	
	action_move(false)
	
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

func is_player_dead():
	var is_dead = not Global.is_alive
	return is_dead

func get_dmg():
	is_knockback = true
	velocity.y = -350
	is_damage.emit()
	
	Global.call_dmg = false  # Resetar após o hit
	dmg_boost()  # Ativa o damage boost

func action_move(jump):
	if Global.is_alive:
		if is_on_ground:
			animation_name = "s" + str(state) + "_run"
			
			if is_jump or jump:
				jump_sfx.play()
				velocity.y = JUMP_SPEED
		
		else:
			animation_name = "s" + str(state) + "_jump"
		
		if is_knockback:
			animation_name = "s" + str(state) + "_hurt"
	
	is_jump = false

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
	
	heal_sfx.play()
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
	
	texture.connect("animation_finished", Callable(self, "_on_animation_finished"))
	
	pass

func dmg_boost():
	if not is_damage_boost:  # Apenas ativa o boost se não estiver ativo
		is_damage_boost = true
		timer.start(2.0)  # Inicia o timer de 2 segundos para invulnerabilidade

func _on_timer_timeout():
	if is_damage_boost:
		is_damage_boost = false  # Desativa o damage boost
		timer.stop()
	pass
