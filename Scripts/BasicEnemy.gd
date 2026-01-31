extends Character

@export var dano_al_contacto: int = 1
@onready var damage_area: Area2D = $DamageArea

func _ready():
	damage_area.body_entered.connect(_on_damage_area_body_entered)

# Si quieres que el enemigo básico no se mueva, en el inspector pon 'velocidad_movimiento' en 0.
# Si quieres que persiga, aquí pondríamos la IA.

func comportamiento_movimiento(_delta):
	# Por ahora, comportamiento básico: No se mueve o patrulla simple
	# Si velocidad_movimiento es 0 en el inspector, se queda quieto.
	pass 

# Podemos hacer que el jefe tenga una muerte especial
func morir():
	# Si tiene mucha vida (es jefe), tal vez soltar un item
	if vidas_maximas > 5:
		print("¡Jefe derrotado!")
	super.morir() # Llama a la función morir() original (queue_free)

# Esta función debe conectarse a la señal "body_entered" del AreaDano del enemigo
func _on_damage_area_body_entered(body):
	# Verificamos si es el jugador (usando la clase base para detectar)
	if body is Character and body.name == "Player":
		# Le pasamos nuestra posición para que el jugador sepa de dónde vino el golpe
		body.recibir_dano(dano_al_contacto, global_position)
