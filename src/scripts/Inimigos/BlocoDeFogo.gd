extends KinematicBody2D

var velocity = Vector2()
var gravity = 600
var jump_force = -400
var has_landed = false
var ground_y = 0

onready var timer_destruir = Timer.new()

func _ready():
	randomize()

	timer_destruir.wait_time = 5.0
	timer_destruir.one_shot = true
	timer_destruir.connect("timeout", self, "_destruir")
	add_child(timer_destruir)
	timer_destruir.start()

	ground_y = position.y

	if velocity == Vector2.ZERO:
		var direction = 1
		if randf() < 0.5:
			direction = -1

		var side_push = rand_range(40, 120) * direction
		velocity = Vector2(side_push, jump_force)

func set_direcao(nova_direcao):
	velocity = nova_direcao.normalized() * 200

func _process(delta):
	if has_landed:
		velocity.x = lerp(velocity.x, 0, 2 * delta) 
		velocity.y = 0
	else:
		velocity.y += gravity * delta

	velocity = move_and_slide(velocity, Vector2.UP)

	# Se tocou o chão
	if not has_landed and is_on_floor():
		has_landed = true

func _destruir():
	queue_free()


func _on_Area2D_body_entered(body):
	if (body.is_in_group("player")):
		body.levar_dano(2)
	
	yield(get_tree().create_timer(1), "timeout")
	queue_free()
