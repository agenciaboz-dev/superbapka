extends Node2D

var obst_path: Array = []
var last_obst_pos : Vector2
var obst_name: String
var spawn_distance: float
var last_obst_position_x : float = 0.0
var range : int
var pos : int
var min_distance := 10
var has_obst : bool
var oldest_node

var obstacles: Array = []

func _ready():
	var range = 0
	has_obst = false
#	self.collision_mask = 4
#	self.collision_layer = 6

func _process(delta):
	if Global.game_running:
		if obst_path.size() > 0:
			spawn_distance = randi_range(420, 420 * 1.5)
			# Verificar se o spawner está longe o suficiente para spawnar um novo obstáculo
			if self.position.x - last_obst_position_x >= spawn_distance:
				#print(obst_path.size())
				spawn_item()

func spawn_scenario_trigger():
	#var scenario_trigger = load()
	pass

func spawn_item():
	var max_obst = 3
	var range = randi_range(0, max_obst)
	var last_obst_x = 0
	
	for i in range:
		var obstacle_object = load(obst_path[randi() % obst_path.size()])
		var attempt = true
		if obstacle_object:
			var obst = obstacle_object.instantiate()
			oldest_node = obstacles.pop_front()
			# Calcular a posição y com base no chão e altura do obstáculo
			
			if oldest_node:
				if obstacles.size() > 4:
					print(obstacles)
					unload_oldest_node()
			
			# Defina a posição do obstáculo
			obst.position = Vector2i(self.position.x * i + min_distance + last_obst_x * i, self.position.y -25)
			obst.body_entered.connect(_on_body_entered) 
			get_parent().add_child(obst)
			obstacles.append(obst)
			#print(obst.position)
			last_obst_pos = self.position
			last_obst_x = 28
		else:
			print("Erro ao carregar o obstáculo: ", obst_path)
		
		last_obst_position_x = last_obst_pos.x
		Global.obst_last_x = last_obst_pos.x
	
func set_path(array_path):
	obst_path = array_path

func unload_oldest_node():
	# Remove o nó mais antigo da lista
	if oldest_node:  # Certifique-se de que o nó ainda existe
		oldest_node.queue_free()  # Descarrega o nó removendo-o da cena

func _on_timer_timeout():
	#print("self.position: ", self.position)
	pass # Replace with function body.


func _on_body_entered(body):
	#print(self.name)
	#Global.player_heal = 25
	#has_obst = true
	pass # Replace with function body.


func _on_body_exited(body):
	#print("saiu")
	#has_obst = false
	pass # Replace with function body.
