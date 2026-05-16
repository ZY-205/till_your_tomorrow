extends Control


func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/levels/prologue/prologue.tscn")


func _on_load_pressed() -> void:
	pass # Replace with function body.


func _on_info_pressed() -> void:
	pass # Replace with function body.


func _on_quit_pressed() -> void:
	get_tree().quit()
