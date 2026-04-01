extends Node

@onready var line := Line2D

func _ready() -> void:
	var line := $"."
	line.width = 5.0
	line.default_color = Color(1.0, 0.0, 0.5, 1.0)
	
	line.add_point(Vector2(-9999, get_tree().get_root().size.y/2))
	line.add_point(Vector2(9999, get_tree().get_root().size.y/2))
