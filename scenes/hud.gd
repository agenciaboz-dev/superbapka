extends CanvasLayer

signal on_pause_action

@onready var pause_btn := $Top_center/pause_button as TouchScreenButton
@onready var unpause_btn :=$Top_center/unpause_button as TouchScreenButton
@onready var title_btn := $Top_center/title_screen_button as TouchScreenButton
@onready var leave_msg := $leave_msg as Label

func _ready():
	unpause_btn.visible = false

func _process(delta):
	print(Global.start_msg)
	$Top_left/ScoreLabel.text = "Distância: " + str(round(Global.score))
	$Center/Game_Info_Label.text = Global.start_msg
	$Top_right/CoinLabel.text = "Moedas: " + str(round(Global.collected_coins))
	#$HighScoreLabel.text = "HIGHSCORE: " + str(Global.high_score)
	if Global.game_running:
		$Center/Game_Info_Label.visible_characters = 0
	
	if not Global.is_alive:
		$Center/Game_Info_Label.visible_characters = -1
		control_visibility()
		pass
		
func control_visibility():
	pause_btn.visible = not get_node("/root/Game").get_tree().paused and Global.is_alive
	unpause_btn.visible = get_node("/root/Game").get_tree().paused and Global.is_alive
	leave_msg.visible = not Global.is_alive
	title_btn.visible = not Global.is_alive
	

func _on_pause_button_pressed():
	on_pause_action.emit()
	control_visibility()
	pass # Replace with function body.


func _on_unpause_button_pressed():
	on_pause_action.emit()
	control_visibility()
	pass # Replace with function body.


func _on_title_screen_button_pressed():
	get_tree().change_scene_to_file("res://scenes/title_screen.tscn")
	pass # Replace with function body.
