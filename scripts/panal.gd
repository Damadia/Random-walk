extends Node

@export var SPAWN_TIME : float = 1.5
@export var LIMIT : int = 10

var pForBees : float

var ROOT_VIEWPORT : Window
var smooth_ani : Tween

@onready var Cam : Camera2D = self.owner.get_node("Camera2D")

var camera_limits : Vector2

@onready var spawner : Timer = $spawner_time

const BeeScene = preload("res://actors/bee.tscn")

@onready var strBtn = $"../Settings/VBoxContainer/Start"
var sss = 1.0
func _enter_tree() -> void:
	smooth_ani = create_tween()
	smooth_ani.set_ease(Tween.EASE_IN)
	smooth_ani.set_trans(Tween.TRANS_QUART)

func _ready() -> void:
	ROOT_VIEWPORT =  get_tree().root
	camera_limits = Vector2(0, ROOT_VIEWPORT.size.x)
	spawner.timeout.connect(spawn)
	strBtn.pressed.connect(start)
	#smooth_ani.tween_property(Cam, "zoom", Vector2(ROOT_VIEWPORT.size.x/3840.0, ROOT_VIEWPORT.size.y/2160.0), 1.5)
	
func start() ->void:
	spawner.start()
	

func _process(delta:float) -> void:
	sss -= delta
	
	if (sss > 0):
		return
	check_resize()	
	sss = 2.0

func spawnBee() -> void:
	if get_children().size() > LIMIT:
		return
	var newBee : Bee = BeeScene.instantiate() 
	newBee.position = Vector2(ROOT_VIEWPORT.size.x/2.0 + randf_range(-1.0,1.0)*200,ROOT_VIEWPORT.size.y/2.0)
	newBee.p = pForBees
	add_child(newBee)
	
func spawn() -> void:
	spawnBee()
	spawner.start()
	
	
func check_resize() -> void:
	var minSize = ROOT_VIEWPORT.size
	var within_limits : Vector2 = camera_limits
	var previous_limits : Vector2 = camera_limits

	for b in get_children():
		if (b is not Bee):
			print(b.get_class())			
			print("Reach here1")
			continue
		if (clamp(b.position.x, minSize.x, minSize.y) == b.position.x):
			print("Reach here2")
			continue
		if b.position.x < camera_limits.x: #Out bounds from the left
			camera_limits.x = b.position.x #new min value
		elif b.position.x > within_limits.x: #within limits
			within_limits.x = b.position.x #new min value 2nd box	
		if b.position.x > camera_limits.y: #Out bounds from the right
			camera_limits.y = b.position.x #new max value
		elif b.position.x < within_limits.y: #within limits
			within_limits.y = b.position.x #new max value 2nd box
		
	var x1 = within_limits.x
	var x2 = within_limits.y
	if (camera_limits.x > within_limits.x && previous_limits != camera_limits):
		x1 = camera_limits.x
	if (camera_limits.y > within_limits.y && previous_limits != camera_limits):
		x2 = camera_limits.x
		
	smooth_ani.tween_property(Cam, "zoom", Vector2(1920.0/(x2 - x1),1920.0/(x2 - x1)),2.0) 
	
