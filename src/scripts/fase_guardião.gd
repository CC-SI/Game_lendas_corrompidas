extends Node2D

var estado = "gameplay"

func _ready():
	$CanvasLayer.associar_fase(self)
