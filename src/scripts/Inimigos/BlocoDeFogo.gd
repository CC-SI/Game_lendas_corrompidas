extends KinematicBody2D

var velocity = Vector2()
var gravity = 600
var has_landed = false
var dano = 1

func _ready():
	velocity = Vector2(rand_range(-300, 800), -400)

func _process(delta):
	if has_landed:
		velocity.x = lerp(velocity.x, 0, 2 * delta)
		velocity.y += gravity * delta
	else:
		velocity.y += gravity * delta

	velocity = move_and_slide(velocity, Vector2.UP)

	# Marca quando tocar no chão
	if not has_landed and is_on_floor():
		has_landed = true
		yield(get_tree().create_timer(0.5), "timeout")
		queue_free()

func _on_Area2D_body_entered(body):
	if body.is_in_group("player"):
		body.levar_dano(dano)
