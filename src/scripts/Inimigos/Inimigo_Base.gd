extends KinematicBody2D
class_name InimigoBase

export var vidas = 3
export var gravidade = 300
export var nome_do_inimigo = "Inimigo"

var velocidade = 100
var direcao = Vector2.ZERO

func follow_player():
	var direcao_horizontal = DadosGlobais.player.global_position.x - global_position.x

	if direcao_horizontal != 0:
		var novo_lado = 1 if direcao_horizontal > 0 else -1
		if has_method("mudarLadoSprite"):
			self.lado = novo_lado
			call("mudarLadoSprite")
			
	direcao = (DadosGlobais.player.global_position - global_position).normalized()
	direcao.y += gravidade
	direcao *= velocidade
	move_and_slide(direcao, Vector2.UP)

func levar_dano(valor):
	vidas -= valor
	print("%s levou %d de dano!" % [nome_do_inimigo, valor])
	if vidas <= 0:
		morrer()
		
func aplicar_dano(valor):
	var player = get_tree().get_nodes_in_group("player")
	if (player.size() > 0):
		player[0].levar_dano(valor)
		print("%s causou %d de dano ao player!" % [nome_do_inimigo, valor])

func aplicar_lentidao(duracao):
	velocidade = 10
	yield(get_tree().create_timer(duracao), "timeout")
	velocidade = 100

func morrer():
	print("%s morreu!" % nome_do_inimigo)
	queue_free()
