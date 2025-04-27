extends Node2D

export var nome_proxima_fase: String

onready var texto_ajuda = $TextoAjuda

export var precisa_inimigos_mortos: bool
export var quantidade_inimigos = 0

var player_na_area = false

func _ready():
	texto_ajuda.visible = false

func _on_Area2D_body_entered(body):
	if body.is_in_group("player"):
		player_na_area = true
		texto_ajuda.visible = true
		
func _on_Area2D_body_exited(body):
	if body.is_in_group("player"):
		player_na_area = false
		texto_ajuda.visible = false

func _process(delta):
	if player_na_area and Input.is_action_just_pressed("interact"):
		if nome_proxima_fase != "":
			get_tree().change_scene_to_file("res://src/Cenas/Fases/" + nome_proxima_fase + ".tscn")
