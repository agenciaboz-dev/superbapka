extends Node2D

var obst_path : Array = []
var last_obst_pos : Vector2
var obst_name: String
var spawn_distance: float
var last_obst_position_x : float = 0.0
var range : int
var pos : int
var min_distance := 10
var has_item : bool

var obstacles: Array = []

func _ready():
	var range = 0
	has_item = false

func _process(delta):
	if Global.game_running:
		if obst_path.size() > 0:
			spawn_distance = randi_range(420, 420 * 1.5)
			# Verificar se o spawner está longe o suficiente para spawnar um novo obstáculo
			if self.position.x - last_obst_position_x >= spawn_distance:
				#print(obst_path.size())
				spawn_obstacle()

func spawn_obstacle():
	var max_obst = 3
	var range = randi_range(0, max_obst)
	var overposition_x = 0
	var last_obst_x = 0
	#print(range)
	for i in range:
		var obstacle_object = load(obst_path[randi() % obst_path.size()])
		var attempt = true
		if obstacle_object:
			var obst = obstacle_object.instantiate()
			
			# Calcular a posição y com base no chão e altura do obstáculo
			var obst_size = obst.get_node("Height_marker").target_position
			var obst_scale = obst.get_node("Sprite2D").scale
			var sprite_height = obst.get_node("Sprite2D").texture.get_height()
			
			if obstacles.size() >= 10:
				unload_oldest_node()
			
			if not has_item:
				# Defina a posição do obstáculo
				obst.position = Vector2i(self.position.x * i + overposition_x + last_obst_x * i, self.position.y + obst_size.y)
				obst.body_entered.connect(_on_body_entered) 
				get_parent().add_child(obst)
				obstacles.append(obst)
				 
				#print(obst.position)
				last_obst_pos = self.position
				overposition_x = min_distance
				last_obst_x = obst_size.x
				#Global.obst_last_width = obst.get_node("Collision").properties.size
		else:
			print("Erro ao carregar o obstáculo: ", obst_path)
		
		last_obst_position_x = last_obst_pos.x
		Global.obst_last_x = last_obst_pos.x
	
func set_path(array_path):
	obst_path = array_path

func unload_oldest_node():
	var oldest_node = obstacles.pop_front()  # Remove o nó mais antigo da lista
	if oldest_node:  # Certifique-se de que o nó ainda existe
		oldest_node.queue_free()  # Descarrega o nó removendo-o da cena

func _on_timer_timeout():
#	print("item_width ",Global.item_last_width)
#	print("item_x ",Global.item_last_x)
	#print("self.position: ", self.position)
	pass # Replace with function body.

func _on_item_spawner_body_exited(body):
	print("saiu")
	has_item = false
	pass # Replace with function body.


func _on_body_entered(body):
	#has_item = true
	pass # Replace with function body.
