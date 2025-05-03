extends Node2D

var vida_coletada = false

func _on_Area2D_body_entered(body):
	if body.is_in_group("player"):
		if vida_coletada:
			return
		
		aumentar_vida(3)
		queue_free()

func aumentar_vida(valor):
	var player = get_tree().get_nodes_in_group("player")
	if (player.size() > 0):
		player[0].aumentar_vida(valor)
