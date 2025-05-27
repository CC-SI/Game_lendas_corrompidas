extends Node2D

onready var texto_ajuda = $TextoAjuda

var player_na_area = false

signal sair_fase

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
		emit_signal("sair_fase")
