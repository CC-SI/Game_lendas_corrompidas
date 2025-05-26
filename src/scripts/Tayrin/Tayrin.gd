extends Node2D
var alvo : Position2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if alvo == null:
		return
	
	global_position = global_position.linear_interpolate(alvo.global_position, _delta)
	#global_position = alvo.global_position

func seguir(node):
	scale = node.scale - (node.scale/4)
	global_position = node.global_position
	alvo = node
