extends Node2D

var metas_completadas = 0
var metas_totales = 5

func sumar_meta():
	metas_completadas += 1
	
	# Usamos Global para el puntaje también
	Global.puntaje += 50 
	print("Puntos: ", Global.puntaje, " | Metas: ", metas_completadas, "/", metas_totales)
	
	if metas_completadas >= metas_totales:
		# ¡Subimos de nivel en la memoria global!
		Global.nivel_actual += 1
		Global.puntaje += 1000 # Bono por pasar de nivel
		
		print("¡NIVEL COMPLETADO! Pasando al nivel: ", Global.nivel_actual)
		
		# Al recargar la escena, las metas se vaciarán solas, 
		# pero los CarLane leerán el nuevo Global.nivel_actual y serán más rápidos.
		get_tree().reload_current_scene()
