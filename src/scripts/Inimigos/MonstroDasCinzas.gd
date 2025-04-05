extends InimigoBase

var perseguindo = false
var alvo = null

func _ready():
	velocidade = 30

func _process(delta):
	if (perseguindo and alvo and alvo.is_inside_tree()):
		var direcao = (alvo.global_position - global_position).normalized()
		direcao.y = 0
		move_and_slide(direcao * velocidade)
		$Sprite.flip_h = direcao.x < 0 # vira o sprite se necessário
		if (direcao.x < 0):
			$Area2D.scale.x = -1
		else:
			$Area2D.scale.x = 1
		
func _on_ZonaVisao_body_entered(body):
	if (body.is_in_group("player")):
		perseguindo = true
		alvo = body
		print("Player está na visão do monstro")


func _on_ZonaVisao_body_exited(body):
	if (body.is_in_group("player")):
		perseguindo = false
		alvo = null
		print("Player saiu da visão do monstro")

func morrer():
	print("Monstro das lavas morreu, fez barulho de morte!")
	queue_free()
