extends CanvasLayer

signal on_pause_action
signal on_restart_action

@onready var pause_btn := $HUD_gameplay/Pause_btn_ctrl/pause_button as TouchScreenButton
@onready var premium_btn := $HUD_gameplay/Premium_btn_ctrl/premium_button as TouchScreenButton
@onready var score_lbl := $HUD_gameplay/Score_lbl_control/ScoreLabel as Label
@onready var coin_lbl := $HUD_gameplay/Coin_lbl_control/CoinLabel as Label
@onready var gameinfo_lbl := $HUD_gameidle/Control_gameinfo/info as Label
@onready var premium_counter_lbl := $HUD_gameplay/Premium_btn_ctrl/premium_counter_label as Label
var game_paused : bool
var distance : String
var coins : String

func _ready():
	Global.premium_count = 0
	game_paused = false
	pass

func _process(delta):
	distance = str(round(Global.score)) + " m"
	coins = str(round(Global.collected_coins)) + " ¢"
	score_lbl.text = distance
	coin_lbl.text = coins
	if Global.game_running:
		premium_counter_lbl.text = str(Global.premium_count) + "/" + str(Global.MAX_PREMIUM)
	
	$HUD_gameover/distance_txt/distance_value_msg.text = "Você correu: " + distance
	$HUD_gameover/title_screen_txt/coins_value_msg.text = "Você ganhou: " + coins
	
	control_visibility()
	
	if not Global.is_alive:
		
		gameinfo_lbl.visible_characters = -1
		pass
	
func control_visibility():
	#unpause_btn.visible = get_node("/root/Game").get_tree().paused and Global.is_alive
	#$HUD_gameplay/Premium_btn_ctrl/premium_button.visible = Global.premium_count
	#$HUD_gameplay/Premium_btn_ctrl/premium_button_disabled.visible = not Global.premium_count
	$HUD_paused.visible = game_paused
	$HUD_gameidle.visible = not Global.game_running and Global.is_alive
	$HUD_gameplay.visible = Global.is_alive and not game_paused and Global.game_running
	$HUD_gameover.visible = not Global.is_alive

func _on_title_screen_button_released():
	on_pause_action.emit()
	get_tree().change_scene_to_file("res://scenes/title_screen.tscn")
	pass # Replace with function body.


func _on_resume_button_released():
	game_paused = false
	on_pause_action.emit()
	control_visibility()
	pass # Replace with function body.


func _on_pause_button_released():
	if Global.game_running:
		game_paused = true
		on_pause_action.emit()
		control_visibility()
	pass # Replace with function body.


func _on_restart_button_released():
	on_restart_action.emit()
	pass # Replace with function body.

func _on_premium_button_released():
	if Global.premium_count:
		Global.use_premium_action()
	pass # Replace with function body.
