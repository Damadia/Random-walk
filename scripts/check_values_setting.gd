extends Node

@export var amountBees : LineEdit
@export var amountSteps : LineEdit
@export var pPosibility : LineEdit
@export var qPosibility : LineEdit
@export var startBtn : Button


@onready var panel_set : Panel = self.get_parent()

var smooth_ani : Tween

func _ready() -> void:
	amountBees.focus_exited.connect(greater0_b)
	amountSteps.focus_exited.connect(greater0_s)
	pPosibility.focus_exited.connect(among01)
	
	startBtn.pressed.connect(on_push_start)
	smooth_ani = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	

func on_push_start() -> void:
	panel_set.hide()
	
func chk_all_setted() ->void:
	if(amountBees.text == "" ||
	amountSteps.text  == "" ||
	pPosibility.text  == ""):
		startBtn.disabled = true
		return
	startBtn.disabled = false
	
	
func greater0_b():
	if !(amountBees.text.is_valid_int()):
		amountBees.clear()
		amountBees.placeholder_text = "El dato de entrada debe de ser un número entero positivo mayor que 0"
		return
	amountBees.text = str(clamp(int(amountBees.text),1,500))
	chk_all_setted()
func greater0_s():
	if !(amountSteps.text.is_valid_int()):
		amountSteps.clear()
		amountSteps.placeholder_text = "El dato de entrada debe de ser un número entero positivo mayor que 0"
		return
	amountSteps.text = str(clamp(int(amountSteps.text),1,2000))
	chk_all_setted()
func among01():
	if !(pPosibility.text.is_valid_float()) and (pPosibility.text != "."):
		pPosibility.clear()
		pPosibility.placeholder_text = "El dato de entrada debe de ser un número en el intervalo [0,1]"
		return
	pPosibility.text = str(clamp(float(pPosibility.text),0.0,1.0))
	$"../../Panal".pForBees = clamp(float(pPosibility.text),0.0,1.0)
	qPosibility.text = "q = 1 - p = 1 - %s = %s" % [pPosibility.text, 1 - float(pPosibility.text)]
	chk_all_setted()
	
