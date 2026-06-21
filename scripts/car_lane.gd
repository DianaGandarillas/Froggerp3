extends Node2D

# --- Configuración desde el editor ---
@export var car_scene: PackedScene          # arrastrá Car.tscn aquí
@export var textura: Texture2D     # el SpriteFrames del tipo de auto

enum TipoCarril { DOS_RAPIDO, TRES_LENTO, DOS_MUY_RAPIDO }
@export var tipo: TipoCarril = TipoCarril.DOS_RAPIDO

@export var direccion: float = 1.0   # 1 = derecha, -1 = izquierda
@export var y_position: float = 0.0  # altura del carril en pantalla

# Configuración de cada tipo
# [cantidad, velocidad, separacion_entre_autos]
const CONFIGS = {
	TipoCarril.DOS_RAPIDO:     [4, 180.0, 180.0],
	TipoCarril.TRES_LENTO:     [5, 100.0, 140.0],
	TipoCarril.DOS_MUY_RAPIDO: [3, 240.0, 260.0],
}

func _ready():
	#position.y = y_position
	_crear_autos()

func _crear_autos():
	var config = CONFIGS[tipo]
	var cantidad   = config[0]
	var velocidad_base  = config[1]
	var separacion = config[2]

	# --- LA MAGIA DEL RANDOM ---
	# 1. Desfase inicial: Elegimos un número al azar entre 0 y 800 píxeles.
	# Esto moverá todo el bloque de autos de este carril hacia adelante o atrás.
	var offset_inicial = randf_range(0, 800)
	
	# 2. Variación de velocidad: Multiplicamos la velocidad base por un 
	# valor entre 0.8 (80%) y 1.2 (120%). Así ningún carril será idéntico a otro.
	var velocidad_final = velocidad_base * randf_range(0.8, 1.2)

	for i in cantidad:
		var auto = car_scene.instantiate()
		add_child(auto)

		# Posición X: Le sumamos nuestro offset aleatorio a la separación normal
		auto.position.x = (i * separacion) + offset_inicial

		# Propiedades con la nueva velocidad alterada
		auto.velocidad = velocidad_final
		auto.direccion = direccion

		# Solo intentamos cambiar la textura si configuraste una en el Inspector
		if textura != null and auto.has_node("Sprite"):
			auto.get_node("Sprite").texture = textura
		auto.inicializar()
