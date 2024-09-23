extends Control


func _on_play_released():
	get_tree().change_scene_to_file("res://scenes/main.tscn")
	pass # Replace with function body.

func _on_quit_released():
	get_tree().quit()
	pass # Replace with function body.
