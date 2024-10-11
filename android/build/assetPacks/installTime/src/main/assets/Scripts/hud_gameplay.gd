extends CanvasLayer

func _process(delta):
	get_tree().paused = not Global.game_running and Global.is_alive
