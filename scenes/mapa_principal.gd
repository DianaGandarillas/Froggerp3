extends Node2D

var metas_completadas = 0
var metas_totales = 5

func sumar_meta():
	metas_completadas += 1
	print("Metas llenas: ", metas_completadas, "/", metas_totales)
	
	if metas_completadas >= metas_totales:
		print("¡NIVEL 1 COMPLETADO! Pasando al siguiente nivel...")
		# Por ahora reiniciaremos todo, luego aquí pondremos la lógica del Nivel 2
		get_tree().reload_current_scene()
