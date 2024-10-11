extends CharacterBody2D

signal is_damage

@onready var timer := $Timer as Timer
@onready var jump_sfx := $jump_sfx as AudioStreamPlayer
@onready var dead_sfx := $dead_sfx as AudioStreamPlayer
@onready var heal_sfx := $heal_sfx as AudioStreamPlayer
@onready var dmg_sfx := $dmg_sfx as AudioStreamPlayer
@onready var anim_player := $Anim_player as AnimationPlayer

const GRAVITY : int = 1300
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
var dmg_value := 0

func _ready():
	apply_skin()
	Global.is_alive = true
	hp = INITIAL_HP
	state = INITIAL_STATE
	Global.connect("use_premium", Callable(self, "_on_use_premium"))
	

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
			hp -= dmg_value
			if hp > 0:
				anim_player.play("Blink")
			is_knockback = false
	
	
	# Apenas permite que o personagem tome dano se o damage boost não estiver ativo
	if is_damage_boost:
		Global.call_dmg = false
	else:
		if Input.is_action_just_pressed("ui_down") or Global.call_dmg:
			get_dmg(25)
	
	if Input.is_action_just_pressed("ui_end"):
		get_dmg(150)
	
	if Input.is_action_just_pressed("ui_up"):
		heal(25, false)
	
	if Input.is_action_just_pressed("ui_home"):
		_on_use_premium()
	
	get_all_stages()
	
	if Input.is_action_just_pressed("ui_accept"):
		is_jump = true
	
	action_move(false)
	
	play_animation()
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

func get_dmg(value):
	is_knockback = true
	velocity.y = -350
	dmg_value = value
	
	dmg_sfx.play()
	is_damage.emit()
	dmg_boost()  # Ativa o damage boost
	
	Global.call_dmg = false  # Resetar após o hit

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
	else:
		anim_player.stop(false)
	
	is_jump = false

func heal(heal_value, mark_overheal):
	#Estamos analisando remover o max_overheal, pois o premium é raro
	var is_overheal = hp > MAX_HP
	
	if mark_overheal:
		hp += heal_value
	else:
		if not is_overheal:
			if hp < MAX_HP:
				hp += heal_value
			
			if hp > MAX_HP:
				hp = MAX_HP
	
	heal_sfx.play()

func apply_skin():
	if texture:
		texture.visible = false
	
	skinid = Global.skin_id
	
	if not skinid:
		skinid = randi_range(1,4)
	
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

func play_animation():
	texture.speed_scale
	texture.play(animation_name)

func dmg_boost():
	if not is_damage_boost:  # Apenas ativa o boost se não estiver ativo
		
		is_damage_boost = true
		timer.start(2.0)  # Inicia o timer de 2 segundos para invulnerabilidade

func _on_timer_timeout():
	if is_damage_boost:
		is_damage_boost = false  # Desativa o damage boost
		anim_player.stop(false)
		timer.stop()
	pass

func _on_use_premium():
	heal(30, true)
