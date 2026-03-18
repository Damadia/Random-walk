extends Node

@export var amountBees : TextEdit
@export var amountSteps : TextEdit
@export var pPosibility : TextEdit
@export var qPosibility : TextEdit


func _ready() -> void:
	amountBees.text_changed.connect(greater0_b)
	amountSteps.text_changed.connect(greater0_s)
	pPosibility.text_changed.connect(among01)
	
	
func greater0_b():
	if !(amountBees.text.is_valid_int()):
		amountBees.clear()
		amountBees.placeholder_text = "El dato de entrada debe de ser un número entero positivo mayor que 0"
		return
	amountBees.text = str(clamp(int(amountBees.text),1,500))
func greater0_s():
	if !(amountSteps.text.is_valid_int()):
		amountSteps.clear()
		amountSteps.placeholder_text = "El dato de entrada debe de ser un número entero positivo mayor que 0"
		return
	amountSteps.text = str(clamp(int(amountSteps.text),1,2000))
func among01():
	if !(pPosibility.text.is_valid_int()) and (pPosibility.text != "."):
		pPosibility.clear()
		pPosibility.placeholder_text = "El dato de entrada debe de ser un número en el intervalo [0,1]"
		return
	pPosibility.text = str(clamp(float(pPosibility.text),0.0,1.0))
	qPosibility.text = "q = 1 - p = 1 - %s = %s" % [pPosibility.text, 1 - int(pPosibility.text)]
	
