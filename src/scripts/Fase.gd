extends Node2D

onready var animacao = $Animacao/AnimationPlayer

var inimigos = []
var total_inimigos

var estado = "gameplay"

func _ready():
	var total_inimigos = len(inimigos)
	$CanvasLayer.associar_fase(self)
