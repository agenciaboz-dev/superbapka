extends Node

const stage_names = [
	{"id": 1, "name": "acai"},
	{"id": 2, "name": "paleta"},
	{"id": 3, "name": "premium"}
	]

var game_running : bool
var ground_width : float
var scenario : int
var character : int
var score : float
var score_modifier : int = 1
var collected_coins: int
var high_score : int
var is_alive : bool
var obst_last_x : float
var item_last_x : float
var item_last_width : float
var obst_last_width : float
var call_dmg := false
var player_heal := 0
var is_overheal : bool
var player_path : String
var player_x : int
var skin_id : int
var start_msg : String
var current_scenario_id := 0
var array_id : Array[int]
var array_id_selected : Array[int]
var is_array_shuffled := false
#fazer um trigger para mudar cenário

func _ready():
	for item in stage_names:
		array_id.append(item["id"])
	array_id.shuffle()
	print(array_id)

func get_scenario_number():
	var return_number = 0
	
	if current_scenario_id == stage_names.size():
		array_id.shuffle()
		current_scenario_id = 0 
	
	return_number = array_id[current_scenario_id]
	
	current_scenario_id += 1
	
	return return_number

func get_scenario_name(num):
	var  scenario_name : String
	for item in stage_names:
		if item["id"] == num:
			scenario_name = item["name"]
			
			return scenario_name

#Tarefas
#reiniciar o game (quando morre) - FEITO
#trocar o estado do sprite - FEITO
#arrumar spawner item/obstáculo - NÃO FINALIZADO
#title screen funcional - FEITO
#Spawnar trigger para trocar cenário
