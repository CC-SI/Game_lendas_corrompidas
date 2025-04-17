extends BolaDeFogoBase

func _ready():
	direcao = Vector2.UP

func _on_Area2D_body_entered(body):
	if body.is_in_group("player"): 
		aplicar_dano(1)  
		queue_free()  
