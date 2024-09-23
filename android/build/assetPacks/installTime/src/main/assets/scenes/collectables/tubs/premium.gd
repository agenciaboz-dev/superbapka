extends Area2D

@onready var animation := $Animation as AnimatedSprite2D
@export var type := "healequip"

func _ready():
	animation.play(str(randi_range(1, 4)))
	
	#Este, apesar de ser um item coletável, diferente dos demais potes, será armazenável e não ativará sua ação no mesmo instante em que é coletado, podendo ser ativado a qualquer instante pelo jogador, desde que possua este em estoque.
	#O armazenamento se dará ao inventário do jogador, não limitando seus usos na mesma partida em que o coletou apenas.


func _on_body_entered(body):
	self.queue_free()
	Global.player_heal = 25
	Global.is_overheal = true
	#Global.player_heal = 25
	#has_obst = true
	pass # Replace with function body.
