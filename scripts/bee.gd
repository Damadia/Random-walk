class_name bee extends Node

enum states {LEFT, RIGHT}

var beeEntity := self 

var p : float
var q : float
const directions := [-1, 1]
const speed : float = 10 # 10 px/s = 1 m/s

var currentState
var animations : AnimatedSprite2D
var stepper : Timer


func _init(probability: float) -> void:
	p = clamp(probability, 0.0, 1.0)
	q = 1 - p
	

func _ready() -> void:
	currentState = states.LEFT
	animations = $Animations
	stepper = $step
	stepper.timeout.connect(on_step_end)
	start_state()
	
func _process(delta: float) -> void:
	if (currentState == states.LEFT):
		self.velocity.x = speed * delta * directions[0]
	if (currentState == states.RIGHT):
		self.velocity.x = speed * delta * directions[1]
		
	
	
func start_state():
	if (currentState == states.LEFT):
		animations.stop()
		animations.play("fly_B")
		stepper.start(0)
	if (currentState == states.RIGHT):
		animations.stop()
		animations.play("fly_F")
		stepper.start(0)
		

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
	
