extends Node

const FILE = "save/highscore.save"

var highscore = 0

func save_score():
	var savefile = FileAccess.open(FILE, FileAccess.WRITE_READ)
	savefile.store_32(highscore)

func load_score():
	var loadfile = FileAccess.open(FILE, FileAccess.READ)
	
	if FileAccess.file_exists(FILE):
		highscore = loadfile.get_32()
