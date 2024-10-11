extends Area2D

signal on_premium_collect(heal_value)

@onready var animation := $Animation as AnimatedSprite2D

func _ready():
	animation.play(str(randi_range(1, 4)))
	
	#Este, apesar de ser um item coletável, diferente dos demais potes, será armazenável e não ativará sua ação no mesmo instante em que é coletado, podendo ser ativado a qualquer instante pelo jogador, desde que possua este em estoque.
	#O armazenamento se dará ao inventário do jogador, não limitando seus usos na mesma partida em que o coletou apenas.

func _on_body_entered(body):
	if body.is_in_group("players"):
		if Global.premium_count < Global.MAX_PREMIUM:
			Global.premium_count +=1
			self.queue_free()
	pass # Replace with function body.
