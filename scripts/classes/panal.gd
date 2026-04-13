class_name Panal
extends Node

@export var SPAWN_TIME : float = 1.5
@export var LIMIT : int = 10

var PanalConfig : RwConfig
var ROOT_VIEWPORT : Window
var smooth_ani : Tween

@onready var Cam : Camera2D = $"../Camera2D"

var camera_limits : Vector2

@onready var spawner : Timer = $spawner_time

const BeeScene = preload("res://actors/bee.tscn")

var NextCheck

func _enter_tree() -> void:
	smooth_ani = create_tween()
	smooth_ani.set_ease(Tween.EASE_IN)
	smooth_ani.set_trans(Tween.TRANS_QUART)
	print(PanalConfig)

func _ready() -> void:
	ROOT_VIEWPORT =  get_tree().root
	camera_limits = Vector2(0, ROOT_VIEWPORT.size.x)
	spawner.timeout.connect(spawn)
	SPAWN_TIME = PanalConfig.FatherConfig["spawnInterval"]
	spawner.wait_time = SPAWN_TIME
	LIMIT = PanalConfig.FatherConfig["limit"]
	NextCheck = PanalConfig.FatherConfig["spawnInterval"]
	start()
	#smooth_ani.tween_property(Cam, "zoom", Vector2(ROOT_VIEWPORT.size.x/3840.0, ROOT_VIEWPORT.size.y/2160.0), 1.5)
	
func start() ->void:
	spawner.start()
	

func _process(delta:float) -> void:
	NextCheck -= delta
	if (NextCheck > 0):
		return
	check_resize()	
	NextCheck = PanalConfig.FatherConfig["spawnInterval"]

func spawnBee() -> void:
	if get_children().size() > LIMIT:
		return
	var newBee : Bee = BeeScene.instantiate() 
	newBee.position = Vector2(ROOT_VIEWPORT.size.x/2.0 + randf_range(-1.0,1.0)*200,ROOT_VIEWPORT.size.y/2.0)
	newBee.remainingSteps = PanalConfig.EntityConfig["steps"]
	newBee.p = PanalConfig.EntityConfig["p"]
	add_child(newBee)
	#Here already exist and ready on the scene
	newBee.set_new_time(PanalConfig.EntityConfig["intervalSpeed"])
	
	
func spawn() -> void:
	spawnBee()
	spawner.start()
	
	
func check_resize() -> void:
	var minSize : Vector2  = Vector2(0,ROOT_VIEWPORT.size.x)
	var within_limits : Vector2 = camera_limits
	var previous_limits : Vector2 = camera_limits
	
	for b in get_children():
		if (b is not CharacterBody2D):
			continue
		if (clamp(b.position.x, minSize.x, minSize.y) == b.position.x):
			print("Bee pos: %s", b.position.x)
			continue
		if b.position.x < camera_limits.x: #Out bounds from the left
			camera_limits.x = b.position.x #new min value
			print("Reach here5")
		elif b.position.x > within_limits.x && b.position.x < minSize.x: #within limits
			within_limits.x = b.position.x #new min value 2nd box	
			print("Reach here6")
		if b.position.x > camera_limits.y: #Out bounds from the right
			print("Bee pos: %s", b.position.x)
			print("Reach here3")
			camera_limits.y = b.position.x #new max value
		elif b.position.x < within_limits.y && b.position.x > minSize.y: #within limits
			print("Bee pos: %s", b.position.x)
			within_limits.y = b.position.x #new max value 2nd box
			print("Reach here4")
			#HAY UN ERROR AQUÍ, CUANDO LAS ABEJAS SALEN POR LA DERECHA Y LUEGO REGRESAN
			# A LA IZQUIERDA (NO NECESARIAMENTE ESTÁN EN EL MINSIZE), LOS DOS VALORES
			# DEL INTERVALO CAMERA_LIMITS SON PUESTOS COMO EL MISMO VALOR 
			# SEGURAMENTE ESTO SUCEDE DE LA MANERA SIMÉTRICA TAMBIÉN

	
	
	var x1 = within_limits.x
	var x2 = within_limits.y
	if (previous_limits.x != camera_limits.x):
		x1 = camera_limits.x
	if (previous_limits.y != camera_limits.y):
		x2 = camera_limits.y
	
	camera_limits = Vector2(x1,x2)
	print("WL: %s\nCL: %s" % [within_limits, camera_limits])
	
	get_tree().create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC).tween_property(Cam, "zoom", Vector2(1920.0/(x2 - x1),1920.0/(x2 - x1)),0.05) 
	
