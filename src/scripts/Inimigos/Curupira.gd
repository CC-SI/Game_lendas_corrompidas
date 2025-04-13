extends InimigoBase

var player = []
var is_follow_player: bool = false
var position_before_is_follow_player
var isKick: bool = false
var lado
var position_return_target = Vector2.ZERO

const velocidade_retorno = 1000


onready var sprite = $Sprite
onready var area2dKick = $Chute

func _ready():
	velocidade = 400

func _process(delta):
	
	
	if is_follow_player:
		follow_player()
	
	if isKick:
		return_to_start(delta)
		if position.distance_to(position_before_is_follow_player) < 5:
			isKick = false
			position = position_return_target

func return_to_start(delta):
	var direction = (position_before_is_follow_player - position).normalized()
	position += direction * velocidade_retorno * delta * 4

func add_list(body, list: Array):
	list.append(body)
	is_follow_player = true
	position_before_is_follow_player = position
	

func remove_list(body, list: Array):
	if list.has(body):
		list.erase(body)
		is_follow_player = false
		isKick = false
		
func mudarLadoSprite():
	sprite.flip_h = lado != 1
	area2dKick.scale.x = lado

func _on_Area2D_body_entered(body):
	if body.is_in_group("player"):
		add_list(body, player)
	
func _on_Area2D_body_exited(body):
	remove_list(body, player)

func _on_Chute_body_entered(body):
	if body.is_in_group("player"):
		isKick = true
		aplicar_dano(2)
		print("Chutou player")
		
