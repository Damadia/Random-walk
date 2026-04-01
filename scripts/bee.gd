class_name Bee
extends CharacterBody2D

enum states {LEFT, RIGHT}

var beeEntity := self 

var p : float : 
	set(val):
		p = clamp(val, 0.0, 1.0)
		q = 1 - p 
var q : float
const directions := [-1, 1]
const speed : float = 50 # 10 px/s = 1 m/s

var currentState
var animations : AnimatedSprite2D
@onready var stepper : Timer = $step
@onready var VEL_PROPORTION : float = stepper.wait_time 

	

func _ready() -> void:
	currentState = states.LEFT
	animations = $Animations
	stepper.timeout.connect(on_step_end)
	animations.play("fly_B")
	start_state()
	
func _process(delta: float) -> void:
	if (currentState == states.LEFT):
		self.position.x += (speed * delta * directions[0])/VEL_PROPORTION
	if (currentState == states.RIGHT):
		self.position.x += (speed * delta * directions[1])/VEL_PROPORTION
		
	
	
func start_state():
	if (currentState == states.LEFT):
		animations.stop()
		animations.play("fly_B")
		stepper.start()
	if (currentState == states.RIGHT):
		animations.stop()
		animations.play("fly_F")
		stepper.start()
		

func exit_state():
	if (currentState == states.LEFT):
		pass
	if (currentState == states.RIGHT):
		pass

func change_state(new_state:String):
	exit_state()
	currentState = states[new_state]
	start_state()


func berDist() -> int:
	var berRes : float = RandomNumberGenerator.new().randf()
	if (berRes <= p):
		return 1
	return 0	

func on_step_end():
	var newState: String = states.find_key(berDist())
	change_state(newState)
	
