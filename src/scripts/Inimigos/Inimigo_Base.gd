extends KinematicBody2D
class_name InimigoBase

export var vidas = 3
export var gravidade = 800
export var nome_do_inimigo = "Inimigo"

var velocidade = 100
var direcao = Vector2.ZERO

var esta_morto = false

func follow_player():
	var direction_x = DadosGlobais.player.global_position.x - global_position.x
	
	if direction_x != 0:
		var new_lado = 1 if direction_x > 0 else -1
		if has_method("mudarLadoSprite"):
			self.lado = new_lado
			call("mudarLadoSprite")
			
	direcao = (DadosGlobais.player.global_position - global_position).normalized()
	direcao.y += gravidade
	direcao *= velocidade
	move_and_slide(direcao, Vector2.UP) 

func levar_dano(valor):
	var material = $Sprite.material
	material.set_shader_param("flash", true)
	yield(get_tree().create_timer(0.25), "timeout")
	material.set_shader_param("flash", false)
	
	vidas -= valor
	
	if vidas <= 0:
		morrer()

func aplicar_dano(valor):
	var player = get_tree().get_nodes_in_group("player")
	if (player.size() > 0):
		player[0].levar_dano(valor)

func aplicar_lentidao(duracao):
	velocidade = 10
	yield(get_tree().create_timer(duracao), "timeout")
	velocidade = 100

func morrer():
	esta_morto = true
