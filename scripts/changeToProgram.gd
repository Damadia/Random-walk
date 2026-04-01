extends Button



func _on_pressed() -> void:
	var vec : Vector2 = Vector2(10,20)
	
	get_tree().change_scene_to_file("res://scenes/hive.tscn")
