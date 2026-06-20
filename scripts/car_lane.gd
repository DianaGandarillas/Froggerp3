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
	TipoCarril.DOS_RAPIDO:     [2, 180.0, 180.0],
	TipoCarril.TRES_LENTO:     [3, 100.0, 140.0],
	TipoCarril.DOS_MUY_RAPIDO: [2, 240.0, 260.0],
}

func _ready():
	position.y = y_position
	_crear_autos()

func _crear_autos():
	var config = CONFIGS[tipo]
	var cantidad   = config[0]
	var velocidad  = config[1]
	var separacion = config[2]

	for i in cantidad:
		var auto = car_scene.instantiate()
		add_child(auto)

		# Posición X: distribuidos a lo largo del carril
		auto.position.x = i * separacion

		# Propiedades
		auto.velocidad = velocidad
		auto.direccion = direccion

		# Asignar el sprite correcto
		auto.get_node("Sprite").texture = textura
		auto.inicializar()
