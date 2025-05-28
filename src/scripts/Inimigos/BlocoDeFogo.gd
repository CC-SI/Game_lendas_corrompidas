extends KinematicBody2D

var velocity = Vector2()
var gravity = 600
var jump_force = -400
var has_landed = false
var dano = 1

func _ready():
	randomize()
	# Define velocidade inicial como uma explosão para cima
	var angle = rand_range(-PI / 3, -2 * PI / 3) # ângulo entre -60° e -120°
	var speed = rand_range(100, 800)
	velocity = Vector2(cos(angle), sin(angle)) * speed

func set_direcao(nova_direcao):
	velocity = nova_direcao.normalized() * rand_range(400, 650)

func _physics_process(delta):
	if has_landed:
		velocity.x = lerp(velocity.x, 0, 2 * delta) 
		velocity.y = 0
	else:
		velocity.y += gravity * delta

	velocity = move_and_slide(velocity, Vector2.UP)

	if not has_landed and is_on_floor():
		has_landed = true


func _on_Area2D_body_entered(body):
	if body.is_in_group("player"):
		var player = get_tree().get_nodes_in_group("player")
		if player.size() > 0:	
			player[0].levar_dano(1)

	queue_free()
