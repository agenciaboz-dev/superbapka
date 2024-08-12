extends CharacterBody2D

const GRAVITY : int = 1500
const JUMP_SPEED : int = -450

@onready var texture := $Animation as AnimatedSprite2D

func _physics_process(delta):
	velocity.y += GRAVITY * delta
	
	if is_on_floor():
		texture.play("run")
		if Input.is_action_pressed("ui_accept"):
			velocity.y = JUMP_SPEED
	else:
		texture.play("jump")
		
	move_and_slide()
