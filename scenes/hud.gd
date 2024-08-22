extends CanvasLayer

@export var score : int
@export var started : bool
@export var high_score : int


func _process(delta):
	$ScoreLabel.text = "SCORE: " + str(score)
	#$HighScoreLabel.text = "HIGHSCORE: " + str(high_score)
	if started:
		$StartLabel.visible_characters = 0
