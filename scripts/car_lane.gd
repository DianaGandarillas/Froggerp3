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
	# VALIDACIÓN DE SEGURIDAD: 
	# Si el 'tipo' actual no existe en el diccionario, forzamos un valor por defecto.
	if not CONFIGS.has(tipo):
		tipo = TipoCarril.DOS_RAPIDO
		
	var config = CONFIGS[tipo]
	var cantidad   = config[0]
	var velocidad_base  = config[1]
	var separacion = config[2]

	# ... (el resto de tu código de la magia del random sigue exactamente igual)

	var offset_inicial = randf_range(0, 800)
	var velocidad_final = velocidad_base * randf_range(0.8, 1.2)

	# --- LA MAGIA DEL ÍNDICE ÚNICO ---
	# randi() % cantidad genera un número entero al azar entre 0 y (cantidad - 1).
	# Por ejemplo, si el carril genera 3 tortugas, esto elegirá el 0, el 1 o el 2.
	var indice_traicionero = randi() % cantidad

	for i in cantidad:
		var auto = car_scene.instantiate()

		# 1. PRIMERO: Configuramos todas sus propiedades y variables
		auto.position.x = (i * separacion) + offset_inicial
		auto.velocidad = velocidad_final
		auto.direccion = direccion

		if textura != null and auto.has_node("Sprite"):
			auto.get_node("Sprite").texture = textura
			
		if "se_sumerge" in auto:
			if i == indice_traicionero:
				auto.se_sumerge = true
			else:
				auto.se_sumerge = false

		# 2. SEGUNDO: Ahora que ya sabe si se sumerge o no, lo añadimos al juego
		# (Esto disparará su _ready() con los valores correctos)
		add_child(auto)

		# 3. TERCERO: Lo inicializamos (esto requiere que ya esté en el árbol con add_child)
		auto.inicializar()
