extends Camera2D

export var limite_direito = 10000000

var alvo: Node2D = null

func _ready():
	limit_right = limite_direito

func _process(delta):
	if alvo:
		global_position = alvo.global_position

func mudar_alvo(novo_alvo):
	alvo = novo_alvo
