class_name Bee
extends CharacterBody2D

enum states {LEFT, RIGHT, IDLE}

var beeEntity := self 

var remainingSteps : int = 10
var p : float : 
	set(val):
		p = clamp(val, 0.0, 1.0)
		q = 1.0 - p 
var q : float
const directions := [-1, 1]
const speed : float = 50 # 50 px/s = 1 m/s in x axis

var currentState
var animations : AnimatedSprite2D
@onready var stepper : Timer = $step 
@onready var VEL_PROPORTION : float = stepper.wait_time 


func set_new_time(new_time : float):
	stepper.wait_time = new_time
	VEL_PROPORTION = new_time
	
func _ready() -> void:
	currentState = states.IDLE
	animations = $Animations
	stepper.timeout.connect(on_step_end)
	animations.play("idle")
	start_state()
	stepper.start()
	
func _process(delta: float) -> void:
	if remainingSteps < 1:
		change_state("IDLE")
	if (currentState == states.LEFT):
		self.position.x += (speed * delta * directions[0])/VEL_PROPORTION
	if (currentState == states.RIGHT):
		self.position.x += (speed * delta * directions[1])/VEL_PROPORTION
	

func start_state():
	if (currentState == states.IDLE):		
		animations.play("idle")
		stepper.start()
	
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
		remainingSteps-=1
	if (currentState == states.RIGHT):
		remainingSteps-=1

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
	
