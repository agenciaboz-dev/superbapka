extends Node

var game_running : bool
var ground_width : float
var scenario : int
var character : int
var skin : int
var score : float
var score_modifier : int = 1
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

#Tarefas
#reiniciar o game (quando morre) - FEITO
#trocar o estado do sprite - FEITO
#arrumar spawner item/obstáculo
