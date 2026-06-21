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
	TipoCarril.DOS_RAPIDO:     [4, 180.0, 300.0],
	TipoCarril.TRES_LENTO:     [5, 100.0, 250.0],
	TipoCarril.DOS_MUY_RAPIDO: [3, 240.0, 400.0],
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

	# 1. Desfase inicial para que los carriles no arranquen alineados
	var offset_inicial = randf_range(0, 800)
	
	# 2. Variación aleatoria base (entre 80% y 120% de la velocidad original)
	var velocidad_aleatoria = velocidad_base * randf_range(0.8, 1.2)
	
	# 3. MULTIPLICADOR DE DIFICULTAD (Orquestador Global)
	# Aumenta la velocidad un 15% por cada nivel superado. 
	# (Nivel 1 = 1.0x, Nivel 2 = 1.15x, Nivel 3 = 1.30x)
	var multiplicador_nivel = 0.85 + ((Global.nivel_actual - 1) * 0.175)
	
	# Esta es la velocidad definitiva que se le inyectará a los objetos
	var velocidad_final = velocidad_aleatoria * multiplicador_nivel

	# Reducir dificultad en nivel 1
	if Global.nivel_actual == 1:
		cantidad = max(2, cantidad - 1)
		separacion *= 1.3

	# --- LA MAGIA DEL ÍNDICE ÚNICO ---
	# Sorteamos qué posición del grupo será la trampa (si aplica)
	var indice_traicionero = randi() % cantidad

	for i in cantidad:
		var auto = car_scene.instantiate()

		# 1. PRIMERO: Configuramos sus propiedades ANTES de que nazca en el árbol
		auto.position.x = (i * separacion) + offset_inicial
		auto.velocidad = velocidad_final
		auto.direccion = direccion

		if textura != null and auto.has_node("Sprite"):
			auto.get_node("Sprite").texture = textura
			
		# Si la escena tiene la variable 'se_sumerge' (las tortugas), aplicamos la trampa
		if "se_sumerge" in auto:
			if i == indice_traicionero:
				auto.se_sumerge = true
			else:
				auto.se_sumerge = false

		# 2. SEGUNDO: Lo añadimos al juego 
		# (Al hacer esto, se ejecuta su _ready() con todas las variables ya configuradas)
		add_child(auto)

		# 3. TERCERO: Lo inicializamos para que calcule sus límites de pantalla
		auto.inicializar()
