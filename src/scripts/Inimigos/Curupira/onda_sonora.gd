extends Area2D

export var escala_inicial = Vector2(0,0)
export var taxa_aumento_escala = Vector2(1,1)

func _ready():
	scale = escala_inicial

func _physics_process(delta):
	var tempo_corrido = delta
	
	var aumento_escala = tempo_corrido * taxa_aumento_escala
	scale = escala_inicial + aumento_escala

func _on_Timer_timeout():
	$AnimationPlayer.play("sumindo")

func _on_Area2D_body_entered(body):
	if body.is_in_group("player"):
		body.levar_dano(1)
