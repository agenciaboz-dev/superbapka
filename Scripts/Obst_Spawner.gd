extends Node2D

var obst_path: Array = []
var screen_size: Vector2
var last_obst
var obst_name: String
var spawn_distance: float
var last_obst_position_x: float = 0.0
var range : int
var pos : int
var min_distance := 10

var obstacles: Array = []

func _ready():
	var range = 0
	screen_size = get_window().size

func _process(delta):
	
	if obst_path.size() > 0:
		spawn_distance = randi_range(screen_size.x + 20, screen_size.x * 1.5)
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
			var obst_size = obst.get_node("Sprite2D").texture.get_size()
			var obst_scale = obst.get_node("Sprite2D").scale
			var sprite_height = obst.get_node("Sprite2D").texture.get_height()
			
			
			
			
			# Defina a posição do obstáculo
			obst.position = Vector2i(self.position.x * i + overposition_x + last_obst_x * i, self.position.y - obst_size.y)
			get_parent().add_child(obst)
			obstacles.append(obst)
			#print(obst.position)
			last_obst_position_x = self.position.x
			
			overposition_x = min_distance
			last_obst_x = obst_size.x
		else:
			print("Erro ao carregar o obstáculo: ", obst_path)
	
func set_path(array_path):
	obst_path = array_path


func _on_timer_timeout():
	#print("self.position: ", self.position)
	#print(pos)
	
	pass # Replace with function body.
