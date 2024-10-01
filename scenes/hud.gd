extends CanvasLayer

signal on_pause_action

@onready var pause_btn := $HUD_gameplay/Pause_btn_ctrl/pause_button as TouchScreenButton
@onready var unpause_btn := $HUD_gameplay/Pause_btn_ctrl/unpause_button as TouchScreenButton
@onready var coin_lbl := $HUD_gameplay/Coin_lbl_control/CoinLabel as Label
@onready var score_lbl := $HUD_gameplay/Score_lbl_control/ScoreLabel as Label
@onready var gameinfo_lbl := $Bottom_left/info as Label

func _ready():
	unpause_btn.visible = false

func _process(delta):
	var sizes = get_window().size
	score_lbl.text = "Distância: " + str(round(Global.score))
	coin_lbl.text = "Moedas: " + str(round(Global.collected_coins))
	#$HighScoreLabel.text = "HIGHSCORE: " + str(Global.high_score)
	
	if Global.game_running:
		gameinfo_lbl.visible_characters = 0
	
	control_visibility()
	
	if not Global.is_alive:
		gameinfo_lbl.visible_characters = -1
		pass
	
func control_visibility():
	pause_btn.visible = not get_node("/root/Game").get_tree().paused and Global.is_alive
	unpause_btn.visible = get_node("/root/Game").get_tree().paused and Global.is_alive
	$HUD_gameplay.visible = Global.is_alive
	$HUD_gameover.visible = not Global.is_alive

func _on_pause_button_pressed():
	on_pause_action.emit()
	control_visibility()
	pass # Replace with function body.

func _on_unpause_button_pressed():
	on_pause_action.emit()
	control_visibility()
	pass # Replace with function body.

func _on_title_screen_button_released():
	get_tree().change_scene_to_file("res://scenes/title_screen.tscn")
	pass # Replace with function body.
