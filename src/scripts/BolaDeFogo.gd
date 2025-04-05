extends KinematicBody2D

export var velocidade_x = 300
export var gravidade = 1200
export var forca_pulo = -800

var velocidade  = Vector2.ZERO

func _ready():
	velocidade.x = velocidade_x
	velocidade.y = forca_pulo

func _process(delta):
	velocidade.y += gravidade * delta
	velocidade = move_and_slide(velocidade)
	yield(get_tree().create_timer(3.0), "timeout")
	queue_free()


func _on_Area2D_body_entered(body):
	if (body.is_in_group("player")):
		body.levar_dano(2)
