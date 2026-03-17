extends Node

@onready var line := Line2D

func _ready() -> void:
	var line := $"."
	line.width = 4.0
	line.default_color = Color(1.0, 0.0, 0.5, 1.0)
	
	line.add_point(Vector2(0, get_tree().get_root().size.y/2))
	line.add_point(Vector2(get_tree().get_root().size.x, get_tree().get_root().size.y/2))
	print(line.points)	
