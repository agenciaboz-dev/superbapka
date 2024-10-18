extends Node2D

const item_path : Array = [
	{"chance": [11, 40], "name": "2l.tscn"},
	{"chance": [41, 100], "name": "1l.tscn"},
	{"chance": [1, 10], "name": "premium.tscn"}
	]


@onready var timer := $Timer as Timer

var last_obst_pos : Vector2
var spawn_distance: float
var last_obst_position_x : float = 0.0
var pos : int
var min_distance := 10
var has_obst : bool
var oldest_node
var obst_root : String
var item_path_custom : Array
var is_game_started : bool

var obstacles: Array = []

func _ready():
	is_game_started = false
	has_obst = false
	set_path("res://scenes/collectables/tubs/")

func _process(delta):
	if Global.game_running:
		
		if obstacles.is_empty() and not is_game_started:
			timer.start(randi_range(0, 10))
			is_game_started = true

func spawn_scenario_trigger():
	#var scenario_trigger = load()
	pass

func spawn_item():
	var max_obst = 3
	var obst_path = ""
	
	item_path_custom = item_path.duplicate(true)
	var random_int = randi_range(1, 100)
	
	item_path_custom.sort_custom(func(a, b): return a["chance"][1] < b["chance"][1])
	
	var obst_name = item_path.filter(func(item): return random_int >= item["chance"][0] and random_int <= item["chance"][1] )[0]
	
	obst_path = obst_root + obst_name["name"]
	
	var obstacle_object = load(obst_path)
	
	if obstacle_object:
		var obst = obstacle_object.instantiate()
		oldest_node = obstacles.pop_front()
		
		# Defina a posição do obstáculo
		obst.position = Vector2i(self.position.x, self.position.y -25)
		get_parent().add_child(obst)
		obstacles.append(obst)
		
		last_obst_pos = self.position
	else:
		print("Erro ao carregar o obstáculo: ", obst_path)
	
	last_obst_position_x = last_obst_pos.x
	Global.obst_last_x = last_obst_pos.x
	
func set_path(array_path):
	obst_root = array_path

func unload_oldest_node():
	# Remove o nó mais antigo da lista
	if oldest_node:  # Certifique-se de que o nó ainda existe
		oldest_node.queue_free()  # Descarrega o nó removendo-o da cena

func _on_timer_timeout():
	spawn_item()
	timer.start(randi_range(0, 10))
	pass # Replace with function body.

func _on_body_exited(body):
	#has_obst = false
	pass # Replace with function body.
