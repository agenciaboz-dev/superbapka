extends CanvasLayer

func _process(delta):
	$ScoreLabel.text = "SCORE: " + str(round(Global.score))
	#$HighScoreLabel.text = "HIGHSCORE: " + str(Global.high_score)
	if Global.game_running:
		$StartLabel.visible_characters = 0
