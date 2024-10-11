extends Area2D

@onready var animation := $Animation as AnimatedSprite2D
@onready var coin_sfx := $coin_sfx as AudioStreamPlayer
var is_passed := false
var delta_time

func _ready():
	animation.play(str(randi_range(1, 7)))
	animation.frame = 0
	$Coin.visible = false

func _process(delta):
	if self.position.x < Global.player_x +150 and not is_passed:
		animation.frame = 1
		is_passed = true
		pass

func _on_body_entered(body):
	var tween = create_tween()
	$Coin.visible = true
	tween.tween_property($Coin, "position", Vector2($Coin.position.x, -50) , 0.3)
	tween.tween_property($Coin, "modulate:a", 0.0 , 0.3)
	
	if not animation.frame == 2:
		coin_sfx.play()
		Global.collected_coins += 1
	
	animation.frame = 2
	
	#has_obst = true
	pass # Replace with function body.
