extends Area2D

var ocupada = false

# Esta función la llamará la rana cuando llegue a la meta
func ocupar() -> bool:
	# Si ya estaba ocupada, devolvemos false para que la rana sepa que no puede entrar
	if ocupada:
		return false
		
	ocupada = true
	$Sprite2D.visible = true # Mostramos la ranita sentada
	
	# Cambiamos su grupo: ya no es una meta, ahora es un obstáculo mortal 
	# (así la rana muere si salta a una meta que ya llenó, como en el original)
	remove_from_group("meta")
	#await get_tree().process_frame
	#add_to_group("peligro") 
	call_deferred("add_to_group", "peligro")
	
	return true
