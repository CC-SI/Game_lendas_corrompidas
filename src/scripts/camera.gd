extends Camera2D

export var limite_direito = 10000000

var alvo: Node2D = null

func _ready():
	pass # Replace with function body.

func _process(delta):
	if alvo:
		global_position = alvo.global_position

func mudar_alvo(novo_alvo):
	alvo = novo_alvo
