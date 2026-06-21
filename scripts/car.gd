extends Area2D

@export var velocidad: float = 150.0
@export var direccion: float = 1.0

var limite_derecha: float
var limite_izquierda: float

func _ready():
	if direccion < 0:
		scale.x = -1

# Esta función la llama car_lane.gd DESPUÉS de asignar la textura
func inicializar():
	var ancho_ventana = get_viewport_rect().size.x
	var ancho_sprite = $Sprite.texture.get_width() * $Sprite.scale.x
	
	limite_derecha   =  ancho_ventana + ancho_sprite
	limite_izquierda = -ancho_sprite

func _process(delta):
	position.x += velocidad * direccion * delta
	_verificar_limites()

func _verificar_limites():
	if direccion > 0 and position.x > limite_derecha:
		position.x = limite_izquierda
	elif direccion < 0 and position.x < limite_izquierda:
		position.x = limite_derecha
