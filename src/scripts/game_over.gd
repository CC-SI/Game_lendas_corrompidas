extends Node

func _on_Botao_Renascer_pressed():
	get_tree().change_scene("res://src/Cenas/Cenario Testes/Cenario Testes.tscn")
	
func _on_Botao_Sair_pressed():
	get_tree().quit()
