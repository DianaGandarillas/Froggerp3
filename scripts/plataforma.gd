extends Area2D

@export var velocidad: float = 150.0
@export var direccion: float = 1.0

var limite_derecha: float
var limite_izquierda: float

func inicializar():
	var ancho_ventana = get_viewport_rect().size.x
	
	# ¡LA MAGIA! Usamos el tamaño del rectángulo de colisión en lugar del Sprite
	var ancho_total = $CollisionShape2D.shape.size.x
	
	limite_derecha   =  ancho_ventana + ancho_total
	limite_izquierda = -ancho_total

func _process(delta):
	position.x += velocidad * direccion * delta
	
	if direccion > 0 and position.x > limite_derecha:
		position.x = limite_izquierda
	elif direccion < 0 and position.x < limite_izquierda:
		position.x = limite_derecha
