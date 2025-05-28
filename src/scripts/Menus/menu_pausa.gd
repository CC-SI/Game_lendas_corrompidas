extends Control

onready var cliqueASP = $Som/Clicar

signal continuar_pressed
signal menu_pressed
signal recomecar_pressed

func _on_Botao_Continuar_pressed():
	cliqueASP.play(0)
	emit_signal("continuar_pressed")

func _on_Botao_Menu_pressed():
	cliqueASP.play(0)
	emit_signal("menu_pressed")


func _on_Botao_Recomear_pressed():
	cliqueASP.play(0)
	emit_signal("recomecar_pressed")
