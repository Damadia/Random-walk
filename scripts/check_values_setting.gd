extends Node

@export var amountBees : LineEdit
@export var spawnSpeed : LineEdit
@export var amountSteps : LineEdit
@export var pPosibility : LineEdit
@export var qPosibility : LineEdit
@export var stepInterval : 	LineEdit

@export var madeBy : Label
@export var escRestartProgram : Label
@export var startBtn : Button


@onready var panel_set : Panel = self.get_parent()

var smooth_ani : Tween

var PanalScene : PackedScene = preload("res://actors/panal.tscn")

func _ready() -> void:
	amountBees.focus_exited.connect(greater0_b)
	spawnSpeed.focus_exited.connect(greater0_ss)
	amountSteps.focus_exited.connect(greater0_s)
	pPosibility.focus_exited.connect(among01)
	stepInterval.focus_exited.connect(greater0_si)
	
	startBtn.pressed.connect(on_push_start)
	smooth_ani = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	
	

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.as_text_keycode() == "Escape":
			var t = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
			t.tween_method(set_font_alpha, 1.0, 0.0, 0.0)
			escRestartProgram.visible = false
			get_tree().reload_current_scene()
			


func on_push_start() -> void:

	panel_set.hide()
	var Panal1 : Panal = PanalScene.instantiate() 
	var EC : Dictionary = {
		"steps" : int(amountSteps.text),
		"p" : float(pPosibility.text),
		"q" : float(qPosibility.text),
		"speed" : 50.0,
		"intervalSpeed" : float(stepInterval.text)
	}
	var FC : Dictionary = {
		"spawnInterval" : float(spawnSpeed.text),
		"limit" : int(amountBees.text
		)
	}
	Panal1.PanalConfig = RwConfig.new(EC, FC)
	owner.add_child(Panal1)
	var t = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	t.tween_method(set_font_alpha, 0.0, 1.0, 2.2).set_delay(1.5)

	
func set_font_alpha(value: float) -> void:
	var themeEsc = escRestartProgram.get_theme()
	themeEsc.set_color("font_color","Label",Color("ffda89", value))
	themeEsc.set_color("font_outline_color","Label",Color("242424", value))
	
func set_font_alpha2(value: float) -> void:
	var themeEsc = madeBy.get_theme()
	themeEsc.set_color("font_color","Label",Color("ffda89", value))
	themeEsc.set_color("font_outline_color","Label",Color("242424", value))
	
func chk_all_setted() ->void:
	if(amountBees.text == "" ||
	amountSteps.text  == "" ||
	pPosibility.text  == "" ||
	spawnSpeed.text == "" ||
	stepInterval.text == ""):
		startBtn.disabled = true
		return
	startBtn.disabled = false
	
	
func greater0_b():
	if !(amountBees.text.is_valid_int()):
		amountBees.clear()
		amountBees.placeholder_text = "La cantidad de abejas debe de ser un número entero positivo mayor que 0"
		return
	amountBees.text = str(clamp(int(amountBees.text),1,500))
	chk_all_setted()
func greater0_s():
	if !(amountSteps.text.is_valid_int()):
		amountSteps.clear()
		amountSteps.placeholder_text = "La cantidad de pasos debe de ser un número entero positivo mayor que 0"
		return
	amountSteps.text = str(clamp(int(amountSteps.text),1,10000))
	chk_all_setted()
func greater0_ss():
	if !(spawnSpeed.text.is_valid_float()):
		spawnSpeed.clear()
		spawnSpeed.placeholder_text = "La velocidad de spawn tiene que ser un decimal mayor que 0.1"
		return
	spawnSpeed.text = str(clamp(float(spawnSpeed.text), 0.1, 100.0))
	chk_all_setted()	
	
func greater0_si():
	if !(stepInterval.text.is_valid_float()):
		stepInterval.clear()
		stepInterval.placeholder_text = "El intervalo de cada paso tiene que ser un decimal mayor que 0.1"
		return
	stepInterval.text = str(clamp(float(stepInterval.text), 0.1, 100.0))
	chk_all_setted()	
func among01():
	if !(pPosibility.text.is_valid_float()) and (pPosibility.text != "."):
		pPosibility.clear()
		pPosibility.placeholder_text = "El dato de entrada debe de ser un número en el intervalo [0,1]"
		return
	pPosibility.text = str(clamp(float(pPosibility.text),0.0,1.0))
	qPosibility.text = "q = 1 - p = 1 - %s = %s" % [pPosibility.text, 1 - float(pPosibility.text)]
	chk_all_setted()
	
