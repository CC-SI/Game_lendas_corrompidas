extends Node2D

onready var animacao = $Animacao/AnimationPlayer

var inimigos = []
var total_inimigos

var tocando_cutscene = false
var esta_pausado = false

func _ready():
	var total_inimigos = len(inimigos)
	$CanvasLayer.associar_fase(self)
