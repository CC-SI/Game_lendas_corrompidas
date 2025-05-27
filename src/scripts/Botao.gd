extends Button
onready var hoverASP = $Hover

func _on_Botao_Continuar_mouse_entered():
	hoverASP.play(0)
